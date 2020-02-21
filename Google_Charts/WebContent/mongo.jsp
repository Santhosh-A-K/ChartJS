<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="com.mongodb.*" %>
<%@ page import = "java.io.*,java.util.*,java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>

  <% MongoClient mongoClient = null;
try {
    mongoClient = new MongoClient();
} catch (Exception e1) {
    // TODO Auto-generated catch block
    e1.printStackTrace();
}
// or, to connect to a replica set, supply a seed list of members
//MongoClient mongoClient = new MongoClient(Arrays.asList(new ServerAddress("localhost", 27017),
  //                                    new ServerAddress("localhost", 27018),
    //                                  new ServerAddress("localhost", 27019)));

DB db = mongoClient.getDB("testdoc");
DBCollection coll;
coll = db.getCollection("testdoc");
BasicDBObject doc = new BasicDBObject("Number1", 1).
        append("Number2", 2).append("Number3", 3);

//System.out.println("Data Display");
coll.insert(doc);
DBCursor cursor = coll.find();
try {
   while(cursor.hasNext()) {
       System.out.println(cursor.next());
   }
} finally {
   mongoClient.dropDatabase("test");
   cursor.close();

}
    %>

</body>
</html>