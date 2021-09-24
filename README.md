QDashboard
==========

Simple dashboard to visualize content in tiles.

Configuration in Qt Creator
---------------------------

In other to fully work, QDashboard need a server-side companion, provided by the qdashboard-server repository.

After running it on "my-server" server, the following defines need to be added to the project:
```
DEFINES+=QDASHBOARD_SERVER_BASE_URI=\\\\\\\"https://my-server/qdashboard/api\\\\\\\" DEFINES+=OPENWEATHER_API_KEY=0123456789abcdef
```
(yes, the escaping of the URI is a bit crazy here, but I didn't find any nicer way)

Where:
* QDASHBOARD_SERVER_BASE_URI points to the api resources for qdashboard-server
* OPENWEATHER_API_KEY contains your API key for weather access
