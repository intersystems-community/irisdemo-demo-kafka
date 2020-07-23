# InterSystems IRIS Data Ingestion and Schema Evolution Example

Demo of InterSystems IRIS with Kafka, Schema Registry, AVRO and Schema Migration

This demo allows you to show:
- Ingestion of **AVRO** documents over Kafka
- InterSystems IRIS **Multi-model** capabilities (JSON, Objects and SQL)
- How InterSystems IRIS can **transform** the JSON object into a canonical structure using transformations and **lookups**
- How InterSystems IRIS can **orchestrate** this work and start a **human workflow** in case of a problem during the transformations
- How InterSystems IRIS can provide bidirectional **data lineage** (from source to canonical and vice-versa)
- How InterSytems IRIS can do **schema evolution** by allowing developers to keep adding new schemas while maintaining proper data lineage
- When configured in batch mode, how InterSystems IRIS can ingest documents at **high speed**


## How to run the demo

**WARNING: If you are running on a Mac or Windows, you must give Docker at least 3Gb of RAM for this demo to run properly. Also, please check this [troubleshooting](https://github.com/intersystems-community/irisdemo-base-troubleshooting) document in case you find problems starting the demo with docker-compose. Disk space available for the docker VM is the most common cause for trouble.**

To run the demo on your PC, make sure you have **Git** and **Docker** installed on your machine. 

Clone this repository to your local machine to get the entire source code. Don't worry, you don't need to rebuild the demo from its source. It is just easier this way. After cloning the repo, change to its directory and start the demo:

```bash
git clone https://github.com/intersystems-community/irisdemo-demo-kafka
cd irisdemo-demo-kafka
docker-compose up
```

When starting, you will see lots of messages from all the containers that are starting. That is fine. Don't worry!

When it is done, it will just hang there, without returning control to you. That is fine too. Just leave this window open. If you CTRL+C on this window, docker compose will stop all the containers and stop the demo.

After all the containers have started, open a browser at [http://localhost:10001/csp/appint/demo.csp](http://localhost:10001/csp/appint/demo.csp) to see the landing page of the demo. When requested, use the credentials **SuperUser/sys** to log in. 

## What is in the package?

On this demo, we use a data simulator to generate REST calls to IRIS. The simulator can be configured to send the REST calls following two different JSON schemas: v1 and v2. Here is an example of the JSON sent using v1:

```JSON
{
    "account_id": "W1B1",
    "name": "Sandy Yapp",
    "dob": "1992-12-31",
    "address": {
        "state": "DE",
        "city": "Cambridge",
        "street": "Ent Boulevard"
    }
}
```

And here is an example of v2:
```JSON
{
    "account_id": "W1A1",
    "fullName": "Vivian Campbell",
    "dob": "1942-03-02",
    "address": {
        "state": "OH",
        "city": "Orlando",
        "street": "Lime Way",
        "zip": "9KMZB"
    }
}
```

As you can see, the two JSON documents are very similar. The idea is to show how IRIS can deal with **Schema Evolution** when ingesting JSON documents over REST. On schema v2, **name** has been renamed to **fullName** and the **address** now contains an additional field called **zip**.

Here is the architecture of the demo:

![Architecture of Demo](https://raw.githubusercontent.com/intersystems-community/irisdemo-demo-restm2/master/image-iris-data-sink/html/landing-page.png?token=ABQT2JHSY2U75QPOHEBDOAS7BKPEE)

This is the landing page of the demo. The one you opened just after you started the demo with **docker-compose up**. Everything on this image is clickable. 

The data simulator is at the left of the image. Just click on its square to open it. It is capable of generating the JSON documents and send it to InterSystems IRIS. Here is an example:

![Simulator Running](https://raw.githubusercontent.com/intersystems-community/irisdemo-demo-restm2/master/img/simulator_running.png?token=ABQT2JGV7XTUYBIKAOZK3O27BKTCE)

After clicking on **Run Test** on the simulator, go back to the demo landing page and click on the green arrow at the right that reads **Normalized Data**. You will see a list of messages that are coming into InterSystems IRIS and being normalized. Click on the **green link of** one of them to see the data lineage (message trace):

![Data Lineage](https://raw.githubusercontent.com/intersystems-community/irisdemo-demo-restm2/master/img/visual_trace.png?token=ABQT2JHK5JT3ED4HROQXOB27BKTRY)

## REST Endpoints x Original Data Repositories

Here is the list of endpoints in this demo on InterSystems IRIS:

- /csp/appint/v1 - POST: Add a new document to the v1 repository
- /csp/appint/v1/id - GET: Retrieve a document from the v1 repository
- /csp/appint/v2 - POST: Add a new document to the v2 repository
- /csp/appint/v2/id - GET: Retrieve a document from the v2 repository

Both endpoints (for v1 and v2) can be used. Each endpoint stores the JSON data on its own data repository inside IRIS (a table). Each repository has its own data transformation that will:
- Map the custom structure to the canonical structure
- Apply lookups to transform coded fields to the standard reference data (x-ref)

Here are the classes/tables for each repository inside IRIS:
- Schema v1 - Original.V1.Customer
- Schema v2 - Original.V2.Customer

If you open these two classes using VSCode or Atelier, you will notice that the follow the JSON schemas at the beginning of this README.

## Where is the canonical model

This demo maps two schemas to a single canonical model. The canonical model is comprised of just one class: **Canonical.Customer**. If you click on the gren square at the right on the demo landing page that reads **Versioned Canonical Customer** you will be taken to a place where you can run SQL queries like:

```SQL
select * from Canonical.Customer
```

If you run this query before starting the simulator, this table will be empty. If you run it after, the table will show the canonical records.

You can also run othe queries to look into the original data store for the two schemas such as:

```SQL
select * from Original_V1.Customer
```

And:

```SQL
select * from Original_V2.Customer
```

## Human Workflow

The work of transforming the original documents to its canonical form is orchestrated by the **Normalization Process**. If the message can not be transformed into the canonical format, the normalization process will start a new **workflow** task so that an application specialist can intervene. 

You will find no problems with v1 documents sent by the simulator. If you configure the simulator to produce **v2 messages**, one every 5000 messages will come with an invalid State. That is on purpose. This will cause a problem on the transformation and it will trigger the workflow.

To configure the simulator to generate v2 messages, click on **Settings** at the top right. Here is the screen for configuring the simulator for schema version v2:

![Configuring Schema Version](https://raw.githubusercontent.com/intersystems-community/irisdemo-demo-restm2/master/img/simulator_configuring_schema_version.png?token=ABQT2JDNCXBDOED5LP65LDC7BKQZC)

Change **REST Schema** to "v2" and click on **Update Configuration**. Now you can click again on **Run Test** to start sending InterSystems IRIS JSON documents with schema v2.

To see the workflow tickets appearing in your workflow inbox, just click on the workflow inbox at the demo landing page.

## Faster!

The simulator **settings** allow you to configure the **Ingestion Batch Size**. It comes with a default value of 1 which is very slow. It is good for demos since it won't flood InterSystmes IRIS with messages while you are speaking and explaining things. But if you want to show more speed, try increasing the batch size to 1000. The simulator will show a much higher ingestion rate.

# Other demo applications

There are other IRIS demo applications that touch different subjects such as NLP, ML, Integration with AWS services, Twitter services, performance benchmarks etc. Here are some of them:
* [HTAP Demo](https://github.com/intersystems-community/irisdemo-demo-htap) - Hybrid Transaction-Analytical Processing benchmark. See how fast IRIS can insert and query at the same time. You will notice it is up to 20x faster than AWS Aurora!
* [Twitter Sentiment Analysis](https://github.com/intersystems-community/irisdemo-demo-twittersentiment) - Shows how IRIS can be used to consume Tweets in realtime and use its NLP (natural language processing) and business rules capabilities to evaluate the tweet's sentiment and the metadata to make decisions on when to contact someone to offer support.
* [HL7 Appointments and SMS (text messages) application](https://github.com/intersystems-community/irisdemo-demo-appointmentsms) -  Shows how IRIS for Health can be used to parse HL7 appointment messages to send SMS (text messages) appointment reminders to patients. It also shows real time dashboards based on appointments data stored in a normalized data lake.
* [The Readmission Demo](https://github.com/intersystems-community/irisdemo-demo-readmission) - Patient Readmissions are said to be the "Hello World of Machine Learning" in Healthcare. On this demo, we use this problem to show how IRIS can be used to **safely build and operationalize** ML models for real time predictions and how this can be integrated into a random application. This **IRIS for Health** demo seeks to show how a full solution for this problem can be built.
* [Fraud Prevention](https://github.com/intersystems-community/irisdemo-demo-fraudprevention) - Apply Machine Learning and Business Rules to prevent frauds in financial services transactions using InterSystems IRIS.
* [Financial Transactions with Fraud and Rewards/cross-sell](https://github.com/intersystems-community/irisdemo-demo-finsrv-crosssell) - Process credit card transactions while keeping a hot data lake current with data aggregated from your core systems. Use this aggregated data to prevent frauds and verify customer elegibility for for rewards as an example of cross-selling. 


# Report any Issues

Please, report any issues on the [Issues section](https://github.com/intersystems-community/irisdemo-demo-finsrv-crosssell/issues).
