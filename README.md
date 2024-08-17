# Chatting application using Ruby on rails

It allows creating new applications where each application can have multiple chats, and each chat contains multiple messages. 

Table of contents:
* Dependencies
* How to run 
* Versions used
* Endpoints
* Models
* Database design 
* Services

### Dependencies
1. Docker
2. Docker Compose

### How to run
1. Clone the repo
2. Run docker-compose using the following command
```
docker-compose up
```

### Versions used
Main framework: Ruby on rails -> v7.1.3
Language: Ruby -> 3.3.3
Containerization: Docker -> v25.0.2
Orchestration: Docker compose -> v2.24.3


### Endpoints

#### Postman Collection

You can download the Postman collection for this project [here](https://github.com/OmarMohamedAwad/Chatting_API/blob/main/Isntabug-Chatting.postman_collection.json).

To import the collection into Postman:
1. Open Postman.
2. Click on "Import" in the top left.
3. Select the file you downloaded.

This collection contains all the necessary requests for this project.

### Models
![image](https://github.com/OmarMohamedAwad/Chatting_API/blob/main/DataBase_Design.png)

### Data flow design
#### I used MySQL in this project: 

1. <b>MySQL</b>: it is used for persistent long term data storage, where all the data eventually is stored, 
to avoid racing conditions: (update the chats_count, messages_count) I used the hocks or callback to handel the before and after action to increase in case on creating and decrease in case of destroy 


### Services

1. Elasticsearch and Searchkick: for searching through messages content
2. Sidekiq: for queuing and executing jobs
3. MySQL
4. Redis
5. Redlock: for handling redis mutex locks