package com.irisdemo.kafka;

import java.io.IOException;
import java.sql.SQLException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

import com.irisdemo.kafka.workersrv.WorkerMetricsAccumulator;
import com.irisdemo.kafka.workersrv.WorkerService;

@CrossOrigin()
@RestController
public class AppController 
{

    @Autowired
    WorkerService workerService;
    
    @Autowired
    WorkerMetricsAccumulator accumulatedMetrics;

    /**
     * This is called by the container HEALTHCHECK
     **/
    @GetMapping(value = "/worker/test")
    public int test() 
    {
        return 1;
    }

    @PostMapping(value="/worker/reset")
    public void reset() throws Exception, IOException, SQLException 
    {
        workerService.resetDemo();
    }


    @PostMapping(value = "/worker/startSpeedTest")
    public void startSpeedTest() throws Exception, IOException, SQLException 
    {
        workerService.startSpeedTest();
    }

    @PostMapping(value = "/worker/stopSpeedTest")
    public void stopSpeedTest() throws Exception
    {
        workerService.stopSpeedTest();
    }
    
    @GetMapping("/worker/getMetrics")
    public WorkerMetricsAccumulator getMetrics() 
    {
        return accumulatedMetrics;
    }


}