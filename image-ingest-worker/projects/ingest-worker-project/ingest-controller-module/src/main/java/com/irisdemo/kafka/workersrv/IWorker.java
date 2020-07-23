package com.irisdemo.kafka.workersrv;

import java.io.IOException;
import java.sql.SQLException;
import java.util.concurrent.CompletableFuture;

import org.springframework.scheduling.annotation.Async;

public interface IWorker 
{
	@Async
	public CompletableFuture<Long> startOneFeed(String nodePrefix, int threadNum) throws IOException, SQLException, ClassNotFoundException;
	
	// public void prepareDatabaseForSpeedTest() throws Exception;
	// public void truncateTable() throws Exception;
	
	public void resetDemo() throws Exception;

	public void initiateKafkaProducer() throws Exception;

	public void closeKafkaProducer() throws Exception;

}
