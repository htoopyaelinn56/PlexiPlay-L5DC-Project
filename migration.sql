-- Create the profile table
create table if not exists public.profiles (
  id uuid references auth.users not null primary key,
  username text
);

-- Create or replace function (this IS supported)
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, username)
  values (new.id, new.raw_user_meta_data->>'username');
  return new;
end;
$$ language plpgsql security definer;

-- Drop trigger if it already exists (required workaround)
drop trigger if exists on_auth_user_created on auth.users;

-- Create trigger
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

create table if not exists public.videos (
  id uuid not null default gen_random_uuid (),
  created_at timestamp with time zone not null default now(),
  created_by uuid not null default auth.uid (),
  title text null,
  thumbnail_url text null,
  video_url text null,
  constraint videos_pkey primary key (id),
  constraint videos_created_by_fkey foreign KEY (created_by) references profiles (id) on update CASCADE on delete CASCADE
) TABLESPACE pg_default;

-- Allow anyone (logged in or not) to UPLOAD to the 'images' and 'videos' buckets
CREATE POLICY "Public Upload"
ON storage.objects
FOR INSERT
TO anon, authenticated
WITH CHECK (
  bucket_id = 'images' OR bucket_id = 'videos'
);

-- Allow anyone to VIEW files in these buckets (Required to get the URL later)
CREATE POLICY "Public View"
ON storage.objects
FOR SELECT
                      TO anon, authenticated
                      USING (
                      bucket_id = 'images' OR bucket_id = 'videos'
                      );