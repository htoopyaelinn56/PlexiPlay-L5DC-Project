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