DROP TABLE IF EXISTS CUSTOMER, SHIPPING, `ORDER`, ORDER_LINE, BILL, INVOICE, VENDOR, VENDOR_MATERIAL, PRODUCT_CREATION, PRODUCT, employee, material;

CREATE TABLE customer (
    customer_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    customer_name VARCHAR(50) NOT NULL,
    street VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state CHAR(2) NOT NULL,
    zip_code INT NOT NULL
);

CREATE TABLE vendor (
    vendor_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    contact_info VARCHAR(255) NOT NULL,
    street VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state CHAR(2) NOT NULL,
    zip_code INT NOT NULL,
    website VARCHAR(255) NOT NULL,
  	extension INT NOT NULL,
  	phone BIGINT NOT NULL,
  	email VARCHAR(255) NOT NULL
);

CREATE TABLE material (
    material_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    type VARCHAR(50) NOT NULL,
    name VARCHAR(50) NOT NULL,
  	purchase_price DOUBLE(8,2) NOT NULL,
  	location_stored VARCHAR(255) NOT NULL
);

CREATE TABLE product (
    part_number INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    description TEXT NOT NULL,
    manufacturer_sku VARCHAR(255) NOT NULL,
    back_ordered VARCHAR(255) NOT NULL,
    sale_price DOUBLE(8,2) NOT NULL,
  	type VARCHAR(255) NOT NULL
);

CREATE TABLE employee (
    employee_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    street VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state CHAR(2) NOT NULL,
    zip_code INT NOT NULL,
    ssn VARCHAR(11) NOT NULL,
    marriage_status VARCHAR(20) NOT NULL,
   # recent_divorce BOOLEAN,
    pay_rate DECIMAL(10, 2) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL,
    `status` VARCHAR(20) NOT NULL,
    position VARCHAR(50) NOT NULL,
    banking_info TEXT NOT NULL,
  	`manager_id` INTEGER,
  	CONSTRAINT `employee_fk` FOREIGN KEY (`manager_id`) REFERENCES `EMPLOYEE`(`employee_id`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE invoice (
  invoice_number INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  material_id INT NOT NULL,
  quantity INT NOT NULL,
  amount_owed DOUBLE(8,2) NOT NULL,
  description TEXT NOT NULL,
  date_sent DATE NOT NULL,
  amount_paid DOUBLE(8,2),
  date_owed DATE NOT NULL,
  vendor_id INT NOT NULL,
  employee_id INT NOT NULL,
  CONSTRAINT invoice_fk1 FOREIGN KEY (vendor_id) REFERENCES vendor(vendor_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT invoice_fk2 FOREIGN KEY (employee_id) REFERENCES employee(employee_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT invoice_fk3 FOREIGN KEY (employee_id) REFERENCES employee(employee_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE bill (
  bill_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  amount_paid DOUBLE(8,2),
  amount_owed DOUBLE(8,2) NOT NULL,
  date_issued DATETIME NOT NULL,
#   date_paid DATETIME NOT NULL,
  date_owed DATETIME NOT NULL,
  description TEXT NOT NULL,
  customer_id INT NOT NULL,
  CONSTRAINT bill_fk FOREIGN KEY(customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `order` (
  tracking_number INT PRIMARY KEY NOT NULL,
#   product_type VARCHAR(100) NOT NULL,
  date_ordered DATE NOT NULL,
  description TEXT NOT NULL,
  payment_info VARCHAR(100) NOT NULL,
  payment_type VARCHAR(100) NOT NULL,
  date_processed DATE NOT NULL,
  bill_id INT NOT NULL,
  customer_id INT NOT NULL,
  employee_id INT NOT NULL,
  CONSTRAINT order_fk1 FOREIGN KEY(bill_id) REFERENCES bill(bill_id),
  CONSTRAINT order_fk2 FOREIGN KEY(customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT order_fk3 FOREIGN KEY(employee_id) REFERENCES employee(employee_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE shipping (
  shipping_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  ship_date DATE NOT NULL,
  street VARCHAR(100) NOT NULL,
  city VARCHAR(50) NOT NULL,
  state CHAR(2) NOT NULL,
  zip_code INT NOT NULL,
  shipping_method VARCHAR(100),
  customer_id INT NOT NULL,
  tracking_number INT NOT NULL,
  CONSTRAINT shipping_fk1 FOREIGN KEY(customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT shipping_fk2 FOREIGN KEY(tracking_number) REFERENCES `order`(tracking_number) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE order_line (
  order_line_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  quantity INT NOT NULL,
  shipping_id INT NOT NULL,
  tracking_number INT NOT NULL,
  part_number INT NOT NULL,
  CONSTRAINT order_line_fk1 FOREIGN KEY(tracking_number) REFERENCES `order`(tracking_number) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT order_line_fk2 FOREIGN KEY(shipping_id) REFERENCES shipping(shipping_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT order_line_fk3 FOREIGN KEY(part_number) REFERENCES product(part_number) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE vendor_material (
  vendor_material_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  quantity INT NOT NULL,
  material_id INT NOT NULL,
  vendor_id INT NOT NULL,
  CONSTRAINT vendor_material_fk1 FOREIGN KEY(material_id) REFERENCES material(material_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT vendor_material_fk2 FOREIGN KEY(vendor_id) REFERENCES vendor(vendor_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE product_creation (
  employee_id INT NOT NULL,
  part_number INT NOT NULL,
  material_id INT NOT NULL,
  PRIMARY KEY (employee_id, part_number, material_id),
  date_time DATETIME NOT NULL,
  quantity INT NOT NULL,
  CONSTRAINT product_creation_fk1 FOREIGN KEY(employee_id) REFERENCES employee(employee_id),
  CONSTRAINT product_creation_fk2 FOREIGN KEY(part_number) REFERENCES product(part_number),
  CONSTRAINT product_creation_fk3 FOREIGN KEY(material_id) REFERENCES material(material_id) ON DELETE CASCADE ON UPDATE CASCADE
);
