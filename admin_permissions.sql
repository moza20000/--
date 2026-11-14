-- شغّل هذا الجزء مرة واحدة في Supabase > SQL Editor
-- يسمح فقط لحسابات legal_admins بتغيير حالة طلب الاستشارة.
grant update (status) on public.legal_consultations to authenticated;

create policy "Only legal admins can update consultation status"
on public.legal_consultations
for update
to authenticated
using (
  exists (
    select 1 from public.legal_admins
    where user_id = (select auth.uid())
  )
)
with check (
  status in ('new', 'reviewing', 'contacted', 'closed')
  and exists (
    select 1 from public.legal_admins
    where user_id = (select auth.uid())
  )
);
