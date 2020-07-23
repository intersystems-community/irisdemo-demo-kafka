package com.irisdemo.kafka.worker;

import java.util.Date;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;

import java.util.Random;

public class Util
{    
	private static final String ALPHA_NUMERIC_STRING = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
	private static final String[] FIRST_NAMES = {"Andrew", "Bob", "Charles", "Dina" , "Elbert", "Francesca", "Gabriel", "Hue", "Isabella", 
												"Juana", "Kathryn", "Luis", "Mike", "Nora", "Oswald", "Patty" ,"Quinn",
												"Robert", "Sandy", "Trish", "Umar", "Vivian", "Waldo", "Xavier", "Yusef", "Zoe"};
	private static final String[] LAST_NAMES = {"Aranda", "Brooks", "Campbell", "Dunn", "Eparvier", "Fabregas", "Gump", "Hernandez", "Iacobelli",
												"Jackson", "Kringle", "Lopez", "Maldonado", "Newman", "Oppenheimer" , "Packer", "Quintana",
												"Robertson", "Sacher", "Tadema", "Ubacke", "Valdez", "Wright", "Xanders", "Yapp", "Zafra"};
	private static final String[] STATES = {"AL", "AK", "AZ" , "AR" ,"CA", "CO", "CT", "DE" , "FL" ,"GA", "HI", "ID", "IL" , "IN" ,"IA", "KS", "KY", "LA" , "ME" ,"MD", "MA", "MI", "MN" , "MO" ,"MT", 
											"NE", "NV", "NH" , "NJ" ,"NM", "NY", "NC", "ND" , "OH" ,"OK", "OR", "PA", "RI" , "SC" ,"SD", "TN", "TX", "UT" , "VT" ,"VA", "WA", "WV", "WI" , "WY" ,"PR" };
    
	
	private static final String [] CITY = {"Boston", "Jacksonville", "Orlando", "Charlston", "San Francisco", "Cambridge", "New Cambridge", "York", "San Juan", "London", "Gondor",
											"Isengard", "San Fransokyo", "Tokyo", "Berlin", "New Boston"};
	private static final String [] STREET = {"Allston", "Barney", "Crom" , "Downtown" ,"Elf", "Dark", "Ent", "Future" , "Grand" ,"Hotel", "India", "Juliet", 
											"Kilo" , "Lime" ,"Mount"};

	private static final String [] STREET_ENDING = {"Alley", "Road", "Way", "Avenue", "Boulevard", "Branch", "Common", "Creek", "Drive"};
										
										
	
	public static String randomAlphaNumeric(int count) 
    {
    	StringBuilder builder = new StringBuilder();
	    while (count-- != 0) 
	    {
	    	int character = (int)(Math.random()*ALPHA_NUMERIC_STRING.length());
	    	builder.append(ALPHA_NUMERIC_STRING.charAt(character));
	    }
	    
	    return builder.toString();
	}
	
	public static String randomName()
	{
		
		String name = FIRST_NAMES[(int)(Math.random() * (FIRST_NAMES.length-1))] + " " + LAST_NAMES[(int)(Math.random() * (LAST_NAMES.length-1))] ;
		return name; 
	}

	public static String randomState()
	{
		return STATES[(int)(Math.random()*(STATES.length-1))];
	}

	public static String randomStreet()
	{
		
		String street = STREET[(int)(Math.random() * (STREET.length-1))] + " " + STREET_ENDING[(int)(Math.random() * (STREET_ENDING.length-1))] ;
		return street;
	}

	public static String randomCity()
	{
		
		return CITY[(int)(Math.random()*(CITY.length-1))];
	}

	
	

    
    public static Date randomDate()
    {
    	Random  rnd;
    	long    ms;

    	// Get a new random instance, seeded from the clock
    	rnd = new Random();

    	// Get an Epoch value roughly between 1940 and 2010
    	// -946771200000L = January 1, 1940
    	// Add up to 70 years to it (using modulus on the next long)
    	//ms = -946771200000L + (Math.abs(rnd.nextLong()) % (70L * 365 * 24 * 60 * 60 * 1000));
    	ms = -946771200000L + (Math.abs(rnd.nextLong()/1000L) % (70L * 365 * 24 * 60 * 60)*1000);

    	// Construct a date
    	return new Date(ms);
    }

    public static java.sql.Timestamp randomTimeStamp()
    {
    	return new Timestamp(randomDate().getTime());
    }

    public static String randomMySQLStringTimeStamp()
    {
    	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    	return sdf.format(randomDate());
	}
	

    
    
}