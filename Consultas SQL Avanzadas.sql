-- Docente: Edwin Eliseo Reyes
-- Consulta 01: Insertar un propietario
INSERT INTO owners(
	first_name, last_name, company_name, email, phone, tax_id, address_line1, address_line2,
	city, state, country, postal_code, created_at, updated_at
) VALUES (
	'Edwin', 'Reyes', 'INFRAMEN', 'edwin.reyes@inframen.edu.sv', '(503) 22766080',
	'20 Avenida Norte y 29 Calle Oriente, Colonia Atlacatl', ''
);

-- Consulta 02: Insertar alojamiento (vinculado al propietario y a un piso)
-- Primero insertamos el alojamiento y lo vinculamos al propietario
INSERT INTO accommodations(
	owner_id, location_id, accommodation_type_id, name, description, max_guests,
	bedroom_count, bathroom_count, base_price_per_night
) VALUES (
	21, 19, 2, 'Villa Sueño Tropical', 'Hermosa villa con vista al mar y piscina privada.',
	6, 3, 2, 150.00
);

-- Segundo insertamos un piso vinculado al alojamiento
INSERT INTO rooms(accommodation_id, room_name, room_code, floor_number, capacity, bed_count, room_price_per_night, is_available)
VALUES(21, 'Penthouse 6', '21-006', 6, 4, 2, 180.90, true);

-- Consulta 03: Resgistramos un huésped y su reserva
-- Primero insertamos el huesped
INSERT INTO guests (first_name, last_name, email, phone, nationality, passport_number)
VALUES ('Carlos', 'García', 'carlos.garcia@email.com', '+503 7555-0123', 'Salvadoreño', 'ABC123456');

-- Luego insertamos la reserva
INSERT INTO bookings (
	guest_id, accommodation_id, room_id, booking_status_id, check_in_date, check_out_date, adult_count,
	child_count, subtotal_amount, tax_amount, discount_amount, total_amount, booking_reference)
VALUES (101, 21, 78, 1, '2026-07-01', '2026-07-013', 4, 3, 2170.8, 260.50, 0, 2431.3, 'BK-NVQHW26X');

-- Consulta 04: Registramos un pago
INSERT INTO payments (booking_id, amount, payment_method, payment_status, transaction_reference)
VALUES (104, 2431.3, 'Credit Card', 'Completed', 'TRX-99887766');

-- Consulta 05: Alojamientos activos
SELECT name, base_price_per_night 
	FROM accommodations 
	WHERE is_active;

-- Consulta 06: Huéspedes por país
SELECT first_name, last_name, email, phone, nationality, passport_number 
	FROM guests 
	WHERE nationality = 'Salvadoreño';

-- Consulta 07: Reservas por fecha
SELECT booking_id, check_in_date, check_out_date, adult_count, child_count, total_nights, subtotal_amount, tax_amount, discount_amount, total_amount 
	FROM bookings 
	WHERE check_in_date BETWEEN '2026-01-01' AND '2026-12-31';

-- Consulta 08: Actualizar precio de un alojamiento
UPDATE accommodations 
	SET base_price_per_night = 175.00, updated_at = CURRENT_TIMESTAMP 
	WHERE accommodation_id = 21;

-- Consulta 09: Actualizar estado de una reserva
UPDATE bookings 
	SET booking_status_id = 2
	WHERE booking_id = 104;

-- Consulta 10: Eliminar un reseña especifica
DELETE FROM reviews 
	WHERE review_id = 5;

-- Consulta 11: Reservas + Huésped (INNER JOIN)
SELECT b.booking_id, g.first_name, g.last_name, b.check_in_date 
	FROM bookings b
	INNER JOIN guests g ON b.guest_id = g.guest_id;

-- Consutal 12: Alojamiento completo (Múltiple JOIN)
SELECT a.name, t.type_name, l.city, l.country, o.first_name AS owner_name
	FROM accommodations a
	JOIN accommodation_types t ON a.accommodation_type_id = t.accommodation_type_id
	JOIN locations l ON a.location_id = l.location_id
	JOIN owners o ON a.owner_id = o.owner_id;

-- Consulta 13: Pagos + Reservas (JOIN combinado)
SELECT p.payment_id, b.booking_reference, p.amount, p.payment_status
	FROM payments p
	JOIN bookings b ON p.booking_id = b.booking_id;

-- Consulta 14: Alojamientos sin reseñas (LEFT JOIN para incluir NULLs)
SELECT a.name 
	FROM accommodations a
	LEFT JOIN reviews r ON a.accommodation_id = r.accommodation_id
	WHERE r.review_id IS NULL;

-- Consulta 15: Huéspedes sin reservas
SELECT g.first_name, g.last_name 
	FROM guests g
	LEFT JOIN bookings b ON g.guest_id = b.guest_id
	WHERE b.booking_id IS NULL;

-- Consulta 16: Total de ingresos (SUM)
SELECT SUM(amount) AS total_revenue 
	FROM payments 
	WHERE payment_status = 'Completed';

-- Consulta 17: Promedio de rating de un alojamiento
SELECT r.accommodation_id, a.name, AVG(r.rating) AS average_rating
	FROM reviews r
	INNER JOIN accommodations a ON a.accommodation_id = r.accommodation_id
	GROUP BY r.accommodation_id, a.name;

-- Consulta 18: Top 3 alojamientos con más reservas
SELECT b.accommodation_id, a.name, COUNT(*) AS total_bookings
	FROM bookings b
	INNER JOIN accommodations a ON a.accommodation_id = b.accommodation_id
	GROUP BY b.accommodation_id, a.name
	ORDER BY total_bookings DESC
	LIMIT 3;

-- Consulta 19: Huéspedes con más de 3 reservas (HAVING)
SELECT b.guest_id, g.first_name, g.last_name, COUNT(*) AS num_reservas
	FROM bookings b
	INNER JOIN guests g ON g.guest_id = b.guest_id
	GROUP BY b.guest_id, g.first_name, g.last_name
	HAVING COUNT(*) > 3;

-- Consulta 20: Obtener el alojamiento más caro (Subquery)
SELECT name, base_price_per_night 
	FROM accommodations 
	WHERE base_price_per_night = (SELECT MAX(base_price_per_night) FROM accommodations);

