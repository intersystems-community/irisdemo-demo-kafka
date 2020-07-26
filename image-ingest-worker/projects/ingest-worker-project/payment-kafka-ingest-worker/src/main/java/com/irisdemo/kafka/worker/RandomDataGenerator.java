package com.irisdemo.kafka.worker;

import java.io.IOException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;
import org.json.simple.JSONObject;

import com.irisdemo.kafka.config.Config;

@Component
@Scope(value = ConfigurableBeanFactory.SCOPE_SINGLETON)
public class RandomDataGenerator
{
	protected static Logger logger = LoggerFactory.getLogger(RandomDataGenerator.class);
    
    @Autowired
    protected Config config;    
	
    protected static String[] randomNames;
	
	protected static String[] randomDates;
	
	protected static String[] randomStreets;

	protected static String[] randomStates;

	protected static String[] randomCities;

	protected static String[] randomZips;
	
    protected static boolean randomMappingInitialized = false;
    
	/*
	 * This method will prepare the statement on TABLE_SELECT and use that to:
	 * - See how many columns the table has
	 * - Create the paramRandomValues and paramDataTypes based on the number of columns
	 * - Loop on each column and create 1000 random values for it.
	 */
	public synchronized void initializeRandomMapping() throws IOException
	{
		int entries = 1000;
		//String typeName;
		
		if (randomMappingInitialized)
			return;

		randomNames = new String[entries];

		randomDates = new String[entries];

		randomStreets = new String[entries];

		randomStates = new String[entries]; 

		randomCities = new String[entries];

		randomZips = new String[entries];
		
		for(int i=0; i<entries; i++)
		{
			randomNames[i] = Util.randomName();
			randomDates[i] = Util.randomMySQLStringTimeStamp();
			randomStreets[i] = Util.randomStreet();
			randomStates[i] = Util.randomState();
			randomCities[i] = Util.randomCity();
			randomZips[i] = Util.randomAlphaNumeric(5);
		
		}
				
		randomMappingInitialized = true;
	}
/*
	public void populateJSONRequest(JSONObject request, String threadPrefix, String schema, int recordNum)
	{
		int numberOfRandomValues = 999;
		JSONObject address = (JSONObject)request.get("address");

		address.put("street", randomStreets[(int)(Math.random()*numberOfRandomValues)]);

		if (config.getIngestionRESTSchemaVersion().equals("v1"))
		{
			address.put("state", randomStates[(int)(Math.random()*numberOfRandomValues)]);
		}
		else
		{
			if ((int)(Math.random()*1000)!=1)
			{
				address.put("state", randomStates[(int)(Math.random()*numberOfRandomValues)]);
			}
			else
			{
				// On schema v2, injecting one invalid state every 1000 records
				address.put("state", "XX");
			}
			
		}

		address.put("city", randomCities[(int)(Math.random()*numberOfRandomValues)]);

		request.put("dob", randomDates[(int)(Math.random()*numberOfRandomValues)]);
		request.put("account_id", threadPrefix+recordNum);
		request.put("address", address);

		if (schema.equals("v1"))
		{
			address.remove("zip");
			request.remove("fullName");
			request.put("name", randomNames[(int)(Math.random()*numberOfRandomValues)]);
		}
		else if (schema.equals("v2"))
		{
			request.remove("name");
			request.put("fullName", randomNames[(int)(Math.random()*numberOfRandomValues)]);
			address.put("zip", randomZips[(int)(Math.random()*numberOfRandomValues)]);
		}
	}
	*/



	
}
