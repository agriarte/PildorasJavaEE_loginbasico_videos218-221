<%-- 
    Document   : recibeUsuario
    Created on : 24-oct-2023, 21:02:40
    Author     : Pedro
--%>


<%@page import="org.apache.commons.codec.digest.DigestUtils"%>
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
    Nombre: <%= request.getParameter("nombre")%><br>

    Apellido: <%= request.getParameter("apellido")%><br>

    Usuario: <%= request.getParameter("usuario")%><br>

    Contraseña: <%= request.getParameter("contra")%><br>

    País: <%= request.getParameter("pais")%><br>

    Tecnología: <%= request.getParameter("tecnologias")%><br>

    <%
        String nombre = request.getParameter("nombre");
        String apellido = request.getParameter("apellido");
        String usuario = request.getParameter("usuario");
        String contra = request.getParameter("contra");
        String pais = request.getParameter("pais");
        String tecno = request.getParameter("tecnologias");
        
        // Calcula el hash SHA-256 de la contraseña
        // ejemplo incompleto muy básico para mostrar como codifificar el password como un hashtag
        // en este capítulo no se profundiza más sobre el tema de hacer un login seguro
        String hashedcontra = DigestUtils.sha256Hex(contra);

        //Conexion
        try {
            //La siguiente línea es para evitar problemas de que el jar no encuentre el driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection miConexion = DriverManager.getConnection("jdbc:mysql://localhost:3306/gestionpedidos", "root", "");

            //controlar si existe usuario
            //consulta preparada que devuelve un ResultSet
            PreparedStatement miPr = miConexion.prepareStatement("SELECT * FROM usuarios WHERE usuario=?");
            miPr.setString(1, usuario);
            ResultSet miRs = miPr.executeQuery();

            if (miRs.next()) {
                out.println("ya existe el usuario. Debería volver");
            } else {
                //si no existe el usuario que lo añada
                Statement miSt = miConexion.createStatement();
                String insSql = "INSERT INTO USUARIOS ( nombre, apellido, usuario, contrasena, pais, tecnologia) "
                        + "VALUES ('" + nombre + "', '" + apellido + "', '" + usuario + "', '" + hashedcontra + "', '" + pais + "', '" + tecno + "')";
                miSt.execute(insSql);
                out.println("Usuario Registrado");
            }
            //fin control usuario único

        } catch (Exception e) {
            e.printStackTrace();
        }

    %>
</html>
