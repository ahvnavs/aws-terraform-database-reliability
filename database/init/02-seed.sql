INSERT INTO hotel_bookings (id, org_id, hotel_id, city, checkin_date, checkout_date, amount, status, created_at)
SELECT
    gen_random_uuid(),
    (ARRAY['e47854cd-51cb-465f-8d26-724d16f9f38e'::uuid, '7a7a3c39-1607-4402-9993-9c8a00dc7c86'::uuid, 'c8f74229-4d6b-4e05-9e6b-a131b514b8a2'::uuid])[floor(random() * 3 + 1)],
    'HOTEL-' || floor(random() * 5 + 1)::text,
    (ARRAY['delhi', 'mumbai', 'bengaluru', 'hyderabad'])[floor(random() * 4 + 1)],
    CURRENT_DATE + (floor(random() * 30)::int * interval '1 day'),
    CURRENT_DATE + (floor(random() * 30 + 5)::int * interval '1 day'),
    (random() * 5000 + 500)::numeric(12,2),
    (ARRAY['CONFIRMED', 'CANCELLED', 'PENDING'])[floor(random() * 3 + 1)],
    NOW() - (floor(random() * 60)::int * interval '1 day')
FROM generate_series(1, 150);
INSERT INTO booking_events (booking_id, event_type, payload)
SELECT
    id,
    'BOOKING_CREATED',
    '{"platform": "web", "browser": "Chrome", "campaign": "summer_sale"}'::jsonb
FROM hotel_bookings
LIMIT 75;
