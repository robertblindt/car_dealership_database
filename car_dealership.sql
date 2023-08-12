-- Source tables are Salesperson, Customer, Mechanic, Car
-- 2nd connection tables are Service_Ticket, Dealership_Receipts
-- 3rd connection tables are Mechanic_Work, Payment

CREATE TABLE customer(
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50)
)

INSERT INTO customer(customer_id, first_name, last_name)
VALUES(0,'Zero','Zero');


CREATE TABLE salesperson(
    salesperson_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50)
)

INSERT INTO salesperson(salesperson_id, first_name, last_name)
VALUES(0,'Zero','Zero');


CREATE TABLE mechanic(
    mechanic_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50)
)

INSERT INTO mechanic(mechanic_id, first_name, last_name)
VALUES(0,'Zero','Zero');


CREATE TABLE car(
    car_id SERIAL PRIMARY KEY,
    make VARCHAR(50),
    model VARCHAR(50),
    car_year INTEGER,
    for_sale BOOLEAN,
    new_car BOOLEAN,
    price NUMERIC(8,2),
    features VARCHAR(255)
)

INSERT INTO car(car_id,make,model,car_year,for_sale,new_car,price,features)
VALUES (0,'Zero','Zero',0,FALSE,FALSE,0,'ZERO');


CREATE TABLE service_ticket(
    service_id SERIAL PRIMARY KEY,
    reason_for_visit TEXT,
    car_id INTEGER,
    FOREIGN KEY(car_id) REFERENCES car(car_id),
    customer_id INTEGER,
    FOREIGN KEY(customer_id) REFERENCES customer(customer_id)
)

INSERT INTO service_ticket(service_id,reason_for_visit,car_id,customer_id)
VALUES(0,'Zero',0,0);


CREATE TABLE dealership_receipt(
    dr_id SERIAL PRIMARY KEY,
    salesperson_id INTEGER,
    FOREIGN KEY(salesperson_id) REFERENCES salesperson(salesperson_id),
    customer_id INTEGER,
    FOREIGN KEY(customer_id) REFERENCES customer(customer_id),
    car_id INTEGER,
    FOREIGN KEY(car_id) REFERENCES car(car_id)
)

INSERT INTO dealership_receipt(dr_id,salesperson_id,customer_id,car_id)
VALUES (0,0,0,0);

-- DROP TABLE dealership_receipts;  -- LEFT AN S IN THE TABLE TITLE ORIGINALLY! OOPS!


CREATE TABLE mechanic_work(
    work_id SERIAL PRIMARY KEY, 
    description TEXT,
    work_date TIMESTAMP,
    part_cost NUMERIC(4,2),
    work_dur NUMERIC(2,2),
    mechanic_id INTEGER,
    FOREIGN KEY(mechanic_id) REFERENCES mechanic(mechanic_id),
    service_id INTEGER,
    FOREIGN KEY(service_id) REFERENCES service_ticket(service_id)
)


CREATE TABLE payment(
    payment_id SERIAL PRIMARY KEY,
    total_cost NUMERIC(6,2),
    dr_id INTEGER,
    FOREIGN KEY(dr_id) REFERENCES dealership_receipt(dr_id),
    service_id INTEGER,
    FOREIGN KEY(service_id) REFERENCES service_ticket(service_id)
)

-------------------------------------------------------------------------------------
--------------------------DATABASE HAS BEEN CREATED!---------------------------------
-------------------------------------------------------------------------------------

-- Insert new salespeople
CREATE OR REPLACE PROCEDURE add_salesperson(
    first_name VARCHAR(50), last_name VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
BEGIN 
    INSERT INTO salesperson(first_name, last_name)
    VALUES(first_name, last_name);
END;
$$;

CALL add_salesperson('Joe', 'Smith');
CALL add_salesperson('Michelle', 'Monty');

SELECT * FROM salesperson;


-- Insert new customer
CREATE OR REPLACE PROCEDURE add_customer(
    first_name VARCHAR(50), last_name VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
BEGIN 
    INSERT INTO customer(first_name, last_name)
    VALUES(first_name, last_name);
END;
$$;

CALL add_customer('Bobby', 'Blindt');
CALL add_customer('David', 'Williams');
CALL add_customer('Sammie', 'Barros');

SELECT * FROM customer;


-- Insert new Mechanic
CREATE OR REPLACE PROCEDURE add_mechanic(
    first_name VARCHAR(50), last_name VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
BEGIN 
    INSERT INTO mechanic(first_name, last_name)
    VALUES(first_name, last_name);
END;
$$;

CALL add_mechanic('Justin', 'Joseph');
CALL add_mechanic('Tony', 'Barros');

SELECT * FROM mechanic;


-- Insert car for inventory (for sale)
-- ORIGINALLY price was a NUMERIC(6,2), SO I HAD TO FIX IT! COMMENTED OUT IS THAT DISCOVER AND WORK
--CREATE OR REPLACE PROCEDURE add_inventory(
--    make VARCHAR(50),
--    model VARCHAR(50),
--    car_year INTEGER,
--    for_sale BOOLEAN,
--    new_car BOOLEAN,
--    price NUMERIC(6,2),
--    features VARCHAR(255)
--) 
--LANGUAGE plpgsql
--AS $$
--BEGIN 
--    INSERT INTO car(make,model,car_year,for_sale,new_car,price,features)
--    VALUES(make,model,car_year,for_sale,new_car,price,features);
--END;
--$$;
--
--CALL add_inventory('Toyota','Tacoma',2023,TRUE,TRUE,3000.00,'AC, Electric Windows, Not much else');
--
--SELECT * FROM car;
---- I messed up my numeric size.  I need NUMERIC(7,2) if I want a max price of 99,999.99
--DELETE FROM car;
--ALTER TABLE car 
--DROP COLUMN price;
--
--ALTER TABLE car 
--ADD COLUMN price NUMERIC(8,2);

CREATE OR REPLACE PROCEDURE add_inventory(
    make VARCHAR(50),
    model VARCHAR(50),
    car_year INTEGER,
    new_car BOOLEAN,
    price NUMERIC(8,2),
    features VARCHAR(255),
    for_sale BOOLEAN DEFAULT TRUE
) 
LANGUAGE plpgsql
AS $$
BEGIN 
    INSERT INTO car(make,model,car_year,for_sale,new_car,price,features)
    VALUES(make,model,car_year,for_sale,new_car,price,features);
END;
$$;

CALL add_inventory('Toyota','Tacoma',2023,TRUE,30000.00,'AC, Electric Windows, Not much else');
CALL add_inventory('Toyota','Tacoma',2013,FALSE,10000.00,'Electric Windows, Rusty Frame, Might be covered under warenty');
CALL add_inventory('Ford','Fushion',2015,FALSE,9850.00,'Well equip');
CALL add_inventory('VW','ID.Buzz',2023,TRUE,50000.00,'Electric Bus');

SELECT * FROM car;


-- Insert customer car (for service when car is not bought from that dealership)
CREATE OR REPLACE PROCEDURE add_customer_car(
    make VARCHAR(50),
    model VARCHAR(50),
    car_year INTEGER,
    features VARCHAR(255),
    price NUMERIC(8,2) DEFAULT 0,
    new_car BOOLEAN DEFAULT FALSE,
    for_sale BOOLEAN DEFAULT FALSE
) 
LANGUAGE plpgsql
AS $$
BEGIN 
    INSERT INTO car(make,model,car_year,for_sale,new_car,price,features)
    VALUES(make,model,car_year,for_sale,new_car,price,features);
END;
$$;


CALL add_customer_car('VW','Passat',2022,'White 4 Door, Leather Seats');
CALL add_customer_car('Dodge','Charger',2018,'Yellow 4 Door, Red Fabric Seats');
CALL add_customer_car('Ford','Focus',2017,'Black, ST1');

SELECT * FROM car;



-- Create a service ticket for a vehicle (bring something into the service shop)
CREATE OR REPLACE PROCEDURE create_service(
    reason_for_visit TEXT,
    car_id INTEGER,
    customer_id INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN 
    INSERT INTO service_ticket(reason_for_visit,car_id,customer_id)
    VALUES(reason_for_visit,car_id,customer_id);
END;
$$;

CALL create_service('Car misfires under mid-load', 14, 1);
CALL create_service('Needs Normal Service', 12, 2);
CALL create_service('Car still misfires under mid-load.  Also engine flutters at idle.', 14, 1);

SELECT * FROM service_ticket;



-- Create a function for mechanics to document their work
--CREATE OR REPLACE PROCEDURE create_work(
--    description TEXT,
--    part_cost NUMERIC(4,2),
--    work_dur NUMERIC(2,2),
--    mechanic_id INTEGER,
--    service_id INTEGER,
--    work_date TIMESTAMP DEFAULT NOW()
--)
--LANGUAGE plpgsql
--AS $$
--BEGIN 
--    INSERT INTO mechanic_work(description,part_cost,work_dur,mechanic_id,service_id,work_date)
--    VALUES(description,part_cost,work_dur,mechanic_id,service_id,work_date);
--END;
--$$;
-- HAD THE SAME ERROR WITH MY NUMERIC HERE! NEED TO DELETE and recreate my price and time columns
-- Max price of 99 dollars for parts instead of 9999 
--CALL create_work('Oil Changed',10, .5, 1, 2);
--
--DELETE FROM mechanic_work;
--SELECT * FROM mechanic_work;
--
--ALTER TABLE mechanic_work 
--DROP COLUMN part_cost;
--ALTER TABLE mechanic_work 
--ADD COLUMN part_cost NUMERIC(6,2);
--
--ALTER TABLE mechanic_work 
--DROP COLUMN work_dur;
--ALTER TABLE mechanic_work 
--ADD COLUMN work_dur NUMERIC(4,2);

CREATE OR REPLACE PROCEDURE create_work(
    description TEXT,
    part_cost NUMERIC(6,2),
    work_dur NUMERIC(4,2),
    mechanic_id INTEGER,
    service_id INTEGER,
    work_date TIMESTAMP DEFAULT NOW()
)
LANGUAGE plpgsql
AS $$
BEGIN 
    INSERT INTO mechanic_work(description,part_cost,work_dur,mechanic_id,service_id,work_date)
    VALUES(description,part_cost,work_dur,mechanic_id,service_id,work_date);
END;
$$;

CALL create_work('Oil Changed',100, .5, 1, 2);
SELECT * FROM mechanic_work;

CALL create_work('Replaced Spark Plugs',250, 1.5, 2, 1);
CALL create_work('Top Half of Engine Replaced',1300, 10.5, 1, 1);
CALL create_work('Reset computers, replaced o2 sensor',150, 2, 2, 3);


SELECT * FROM mechanic_work;



-- Create a dealership receipt
CREATE OR REPLACE PROCEDURE create_dealership_receipt(
    salesperson_id INTEGER,
    customer_id INTEGER,
    car_id_to_sell INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN 
    -- Updates the inventory so that the car is no longer for sale
    UPDATE car
    SET for_sale = FALSE 
    WHERE car.car_id = car_id_to_sell ;
    -- Creates the customer receipt
    INSERT INTO dealership_receipt(salesperson_id,customer_id, car_id)
    VALUES(salesperson_id,customer_id, car_id_to_sell);
END;
$$;

-- DROP PROCEDURE create_dealership_receipt;

SELECT * FROM salesperson;
SELECT * FROM customer;
SELECT * FROM car;

-- This is essentially selling the 2023 Taco to David Williams
CALL create_dealership_receipt(1,2,8);
CALL create_dealership_receipt(2,3,10);

SELECT * FROM dealership_receipt;
SELECT * FROM car;


-- Create the payment instance

-- Find the cost of the vehicle
SELECT price 
FROM car c 
WHERE car_id = (
    SELECT car_id 
    FROM dealership_receipt 
    WHERE dr_id = 1
);

-- Find the part costs
SELECT sum(part_cost)
FROM mechanic_work
WHERE service_id = 1
GROUP BY service_id;

-- Find the total hours worked and multiply by 7
SELECT sum(work_dur)*70 AS work_hour_cost
FROM mechanic_work
WHERE service_id = 1
GROUP BY service_id;

-- total repair costs
SELECT sum(part_cost) + sum(work_dur)*70 AS repair_costs
FROM mechanic_work
WHERE service_id = 1
GROUP BY service_id;

-- Car and repair costs
SELECT sum(all_prices) FROM(
SELECT price AS all_prices
FROM car c 
WHERE car_id = (
    SELECT car_id 
    FROM dealership_receipt 
    WHERE dr_id = 1
)
UNION 
SELECT sum(part_cost) + sum(work_dur)*70 AS repair_costs
FROM mechanic_work
WHERE service_id = 2
GROUP BY service_id) AS total;



-- Create a stored function to get total cost 
CREATE OR REPLACE FUNCTION total_price(
    des_dr_id INTEGER DEFAULT 0,
    des_service_id INTEGER DEFAULT 0
)
RETURNS TABLE (
    total_price NUMERIC(8,2)
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT sum(all_prices) AS tot 
    FROM(
    SELECT price AS all_prices
    FROM car c 
    WHERE car_id = (
        SELECT car_id 
        FROM dealership_receipt 
        WHERE dr_id = des_dr_id
    )
    UNION 
    SELECT sum(part_cost) + sum(work_dur)*70 AS repair_costs
    FROM mechanic_work
    WHERE service_id = des_service_id
    GROUP BY service_id) AS total;
END;
$$;

SELECT * FROM total_price(1,2)

--ALTER TABLE payment 
--DROP COLUMN total_cost;
--ALTER TABLE payment 
--ADD COLUMN total_cost NUMERIC(8,2);



-- The command to create the inserts
CREATE OR REPLACE PROCEDURE create_payment(
    des_dr_id INTEGER DEFAULT 0,
    des_service_id INTEGER DEFAULT 0
)
LANGUAGE plpgsql
AS $$
BEGIN 
    INSERT INTO payment(total_cost,dr_id,service_id)
    VALUES(total_price(des_dr_id,des_service_id), 
    des_dr_id, 
    des_service_id);
END;
$$;

SELECT * FROM dealership_receipt dr ;
CALL create_payment(1,2);
CALL create_payment(0,1);
CALL create_payment(2,0);
CALL create_payment(0,3);

SELECT * FROM payment; 


SELECT * FROM service_ticket;

SELECT * FROM mechanic_work;



-- Get a sales persons number of sales, and sales total
SELECT count(car.price) AS num_sales, sum(car.price) AS total_sales
FROM dealership_receipt
JOIN car
ON car.car_id = dealership_receipt.car_id
WHERE salesperson_id = 1
GROUP BY salesperson_id;

-- Create a stored function to get total cost 
-- THIS DOESNT WORK FOR SOME REASON... WILL MOVE ON TO PULL A MECHAICS WORK
--CREATE OR REPLACE FUNCTION query_salesperson_total(
--    des_salesperson_id INTEGER
--)
--RETURNS TABLE (
--    num_sales INTEGER,
--    total_price NUMERIC
--)
--LANGUAGE plpgsql
--AS $$
--BEGIN
--    RETURN QUERY 
--    SELECT count(car.price) AS num_sales, sum(car.price) AS total_sales
--    FROM dealership_receipt
--    JOIN car
--    ON car.car_id = dealership_receipt.car_id
--    WHERE salesperson_id = des_salesperson_id
--    GROUP BY salesperson_id;
--END;
--$$;
--
--DROP FUNCTION query_salesperson_total;
--
--
--SELECT * FROM query_salesperson_total(1);
--
SELECT * FROM mechanic_work;



-- Query what work a mechanic has done.
CREATE OR REPLACE FUNCTION query_mechanics_work(
    des_mechanic_id INTEGER
)
RETURNS TABLE (
    description TEXT,
    work_dur NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT mk.description, mk.work_dur
    FROM mechanic_work mk
    WHERE mechanic_id = des_mechanic_id;
END;
$$;

SELECT * FROM query_mechanics_work(2)
-- Add a message to service 

-- remove car from sales because break pedal explode 

-- add customer notes



-- See service history of a car
SELECT * FROM mechanic_work;
SELECT * FROM service_ticket;

-- Query for mechanic work for cars with a certain car_id
SELECT description, part_cost, work_dur
FROM mechanic_work
WHERE service_id IN (
    SELECT service_id 
    FROM service_ticket
    WHERE car_id = 14
);


CREATE OR REPLACE FUNCTION query_car_work(
    des_car_id INTEGER
)
RETURNS TABLE (
    description TEXT,
    part_cost NUMERIC,
    WORK_dur NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT mw.description, mw.part_cost, mw.work_dur
    FROM mechanic_work mw
    WHERE service_id IN (
        SELECT service_id
        FROM service_ticket st
        WHERE car_id = des_car_id);
END;
$$;


-- my focus
SELECT * FROM query_car_work(14);
-- other car
select * FROM query_car_work(12);


