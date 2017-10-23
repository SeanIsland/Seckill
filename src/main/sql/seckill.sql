--秒杀执行存储过程
DELIMITER $$  --换行符转换为$$
--定义存储过程
--参数：in输入参数;out输出参数
--count_count()：返回上一条修改类型sql（delete,insert,update）的影响行数。
	--结果是0表示未修改数据;大于0表示修改的行数;小于0表示sql错误/未执行修改sql
CREATE PROCEDURE `seckill`.`excuteSeckill`(IN fadeSeckillId bigint,IN fadeUserPhone bigint,IN fadeKillTime TIMESTAMP ,OUT fadeResult INT)
  BEGIN
    DECLARE insert_count INT DEFAULT 0;
    START TRANSACTION ;
    INSERT IGNORE INTO success_killed(seckill_id,user_phone,state) VALUES (fadeSeckillId,fadeUserPhone,0);  --先插入购买明细
    SELECT row_count() INTO insert_count;
    IF(insert_count = 0) THEN
      ROLLBACK ;
      SET fadeResult = -1;   --重复秒杀
    ELSEIF(insert_count < 0) THEN
      ROLLBACK ;
      SET fadeResult = -2;   --内部错误
    ELSE   --已经插入购买明细，接下来要减少库存
      UPDATE seckill SET number = number -1 WHERE seckill_id = fadeSeckillId AND start_time < fadeKillTime AND end_time > fadeKillTime AND number > 0;
      SELECT row_count() INTO insert_count;
      IF (insert_count = 0)  THEN
        ROLLBACK ;
        SET fadeResult = 0;   --库存没有了，代表秒杀已经关闭
      ELSEIF (insert_count < 0) THEN
        ROLLBACK ;
        SET fadeResult = -2;   --内部错误
      ELSE
        COMMIT ;    --秒杀成功，事务提交
        SET  fadeResult = 1;   --秒杀成功返回值为1
      END IF;
    END IF;
  END;
$$
--存储过程定义结束
DELIMITER ;

SET @fadeResult = -3;
--执行存储过程
CALL excuteSeckill(1003,13813813822,NOW(),@fadeResult);
--获取结果
SELECT @fadeResult;

--存储过程
--1：存储过程优化：事务行级锁持有的时间
--2：不要过度依赖存储过程
--3：简单的逻辑可以应用存储过程
--4：QPS:一个秒杀单6000/qps
