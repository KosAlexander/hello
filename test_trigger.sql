USE shop_armor;

DROP TABLE IF EXISTS archive_buys;
CREATE TABLE archive_buys( 
	id  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT KEY,
	oreder_id BIGINT UNSIGNED NOT NULL,
    basket_id BIGINT UNSIGNED,
    product_id BIGINT UNSIGNED,
    total BIGINT UNSIGNED DEFAULT 1 COMMENT ' оличество заказанных товарных позиций',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
  
) ENGINE=Archive;


DROP TRIGGER IF EXISTS update_archive;
DELIMITER //

CREATE TRIGGER update_archive AFTER UPDATE ON orders 
FOR EACH ROW 
BEGIN
	IF NEW.status = 'complated' THEN  
    INSERT INTO archive_buys (oreder_id, basket_id, product_id, created_at, updated_at) 
    VALUES (OLD.id,OLD.basket_id,OLD.product_id,OLD.total, OLD.created_at, NEW.updated_at);
	END IF ;
END//

DELIMITER ;

UPDATE orders SET status = 'complated' WHERE id = '15';


USE shop_armor;

SELECT p.user_id		
FROM profiles p
JOIN baskets b ON p.user_id = b.user_id
JOIN orders o ON b.id = o.basket_id
WHERE o.status IN ('') 
;
DROP TRIGGER IF EXISTS change_user_status;
DELIMITER //

DROP TRIGGER IF EXISTS change_user_status//

CREATE TRIGGER change_user_status AFTER UPDATE ON orders
FOR EACH ROW
BEGIN
	DECLARE @id INT;
	SET @id = (SELECT p.user_id 
				FROM profiles p
				JOIN baskets b ON p.user_id = b.user_id
				JOIN orders o ON b.id = o.basket_id
				WHERE o.status IN (NEW.status));
	IF NEW.status = 'complated' THEN
  	UPDATE profiles
	SET profiles.status = 'active'
    WHERE profiles.user_id = @id;
	  		
  END IF;
END//

DELIMITER ;

UPDATE orders SET status = 'complated' WHERE id = '15';









