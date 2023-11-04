<%-- 
    Document   : recibeUsuario
    Created on : 24-oct-2023, 21:02:40
    Author     : Pedro
--%>


<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>

    <h1>Datos recibidos</h1>
    Nombre(usuario): <%= request.getParameter("usuario")%><br>

    Contraseña: <%= request.getParameter("contra")%><br>

    <%

        try {
            String usuario = request.getParameter("usuario");
            String contra = request.getParameter("contra");
            //Conexion
            //Necesario para carga dinámica de la clase. Sin esto da error de que no puede cargar JDBC      
            //La siguiente línea es para evitar problemas de que el jar no encuentre el driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection miConexion = DriverManager.getConnection("jdbc:mysql://localhost:3306/gestionpedidos", "root", "");
           
            //consulta preparada que devuelve un ResultSet
            String sql = "SELECT * FROM usuarios WHERE usuario=? AND contrasena=?";
            
            //IMPORTANTE: En el video cuando se crea la PreparedStatement no es necesario añadir los parámetros de tipo de ResultSet.
            //En mi entorno no funcionaba sin dar error el ResultSet de tipo "absolute(1)" al no estar habilitado la navegación absoluta. 
            //Para solucionarlo añadir junto con la sentencia, los 2 parámetros de tipo de ResultSet
            PreparedStatement miPr = miConexion.prepareStatement(sql,ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            miPr.setString(1, usuario);
            miPr.setString(2, contra);
            ResultSet miRs = miPr.executeQuery();

            int resultSetType = miRs.getType();
            out.println("Tipo de Resulset: " + resultSetType + "<br>");               
            if (resultSetType == ResultSet.TYPE_FORWARD_ONLY) {
                out.println("Este ResultSet no admite navegación absoluta.<br>");
            } else {
                out.println("Este ResultSet admite navegación absoluta.<br>");
            }

            if (miRs.absolute(1)) {
                out.println("El usuario existe<br>");
                out.println("Nombre: " + miRs.getString(2) + "<br>");
            } else {
                out.println("No existe el usuario");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

    %>
</html>
