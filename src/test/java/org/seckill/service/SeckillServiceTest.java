package org.seckill.service;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.seckill.dto.Exposer;
import org.seckill.dto.SeckillExecution;
import org.seckill.entity.Seckill;
import org.seckill.exception.RepeatKillException;
import org.seckill.exception.SeckillCloseException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

/**
 * Created by Sean on 17/10/20.
 */
@RunWith(SpringJUnit4ClassRunner.class)
//告诉junit spring的配置文件
@ContextConfiguration({"classpath:spring/spring-dao.xml", "classpath:spring/spring-service.xml"})

public class SeckillServiceTest {
    private final Logger logger= LoggerFactory.getLogger(this.getClass());

    @Autowired
    private SeckillService seckillService;

    //@Test
    public void getSeckillList() throws Exception {
        List<Seckill> list=seckillService.getSeckillList();
        logger.info("lisg={}",list);
    }

    //@Test
    public void getById() throws Exception {
        long seckillId=1000;
        Seckill seckill=seckillService.getById(seckillId);
        logger.info("seckill={}",seckill);
    }

    //@Test  可以省略该测试，因为一下testSeckillLogin测试中已经包含该测试环节
    public void testExportSeckillUrl() throws Exception {
    	long id = 1000;
    	Exposer exposer = seckillService.exportSeckillUrl(id);
    	logger.info("exposer={}", exposer);
    }
    
    //@Test//集成测试，完整逻辑代码测试，注意可重复执行
    public void testSeckillLogin() throws Exception {
        long seckillId=1000;
        Exposer exposer=seckillService.exportSeckillUrl(seckillId);
        if (exposer.isExposed()) {
        	logger.info("exposer={}", exposer);
            long userPhone=13476191876L;
            String md5=exposer.getMd5();
            try {
                SeckillExecution execution = seckillService.executeSeckill(seckillId, userPhone, md5);
                logger.info("result={}", execution);
            }catch (RepeatKillException e) {
            	logger.info(e.getMessage());
            }catch (SeckillCloseException e1) {
            	logger.info(e1.getMessage());
            }
        }else {
            //秒杀未开启
        	logger.info("exposer={}", exposer);
        }
    }
    
    @Test
    public void executeSeckillProcedure(){
    	long seckillId=1002;
    	long userPhone=1338888666;
    	Exposer exposer = seckillService.exportSeckillUrl(seckillId);
    	if(exposer.isExposed()) {
    		String md5 = exposer.getMd5();
    		SeckillExecution execution = seckillService.executeSeckillProcedure(seckillId, userPhone, md5);
    		logger.info(execution.getStateInfo());
    	}
    }
}