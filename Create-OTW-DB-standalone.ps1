choco install sqlserver-cmdlineutils --version=14.0
choco install mssqlserver2014-sqllocaldb
# choco install sqlserver2014express
# choco install sql-server-management-studio

sqllocaldb create "OTW"
sqlcmd -S "(localdb)\otw" -E -Q "CREATE DATABASE [OrganizerToWeb] ON PRIMARY ( NAME=[OrganizerToWeb], FILENAME = '$($env:APPDATA)\localdb_otw\OrganizerToWeb.mdf');"
sqlcmd -S "(localdb)\otw" -E -Q "CREATE DATABASE [TRTA.WebPrint] ON PRIMARY ( NAME=[TRTA.WebPrint], FILENAME = '$($env:APPDATA)\localdb_otw\TRTA.WebPrint.mdf');"
sqlcmd -S "(localdb)\otw" -E -d "TRTA.WebPrint" -i "WebPrint_Schema_Update.sql"
sqlcmd -S "(localdb)\otw" -E -Q "select name from sys.databases"
