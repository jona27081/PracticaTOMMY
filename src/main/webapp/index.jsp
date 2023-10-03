<%@ page import="org.uv.crudalumnos.DAOAlumno" %>
<%@ page import="org.uv.crudalumnos.Alumno" %>

<%-- 
    Document   : index
    Created on : 29 sep. 2023, 2:35:31 a. m.
    Author     : zarcorp
--%>

<%
    DAOAlumno dao = new DAOAlumno();

    String action = request.getParameter("action");
    if ("login".equals(action)) {
        // Obtener los valores del formulario
        String correo = request.getParameter("textcorreo");
        String telefono = request.getParameter("texttelefono");

        // Verificar las credenciales del usuario
        Alumno alumno = dao.login(correo, telefono);

        if (alumno != null) {
            // Inicio de sesión exitoso
            session.setAttribute("usuario", alumno);
            response.sendRedirect("crud.jsp"); // Redirigir al usuario a la página después del inicio de sesión exitoso
        } else {
            // Inicio de sesión fallido
            response.sendRedirect("index.jsp?error=1"); // Redirigir al usuario a la página de inicio de sesión con un mensaje de error
        }
    }
%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/css/bootstrap.min.css"
              integrity="sha384-0evHe/X+R7YkIZDRvuzKMRqM+OrBnVFBL6DOitfPri4tjfHxaWutUpFmBp4vmVor" crossorigin="anonymous" />
        <title>JSP Page</title>
    </head>
    <body>
        <div class="container">
            <div class="row justify-content-center mt-5">
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-header bg-dark text-white text-center">
                            <h1 class="display-4">INICIAR SESIÓN</h1>
                        </div>
                        <div class="card-body">
                            <form method="post" action="index.jsp">
                                <input type="hidden" name="action" value="login">
                                <div class="form-group">
                                    <label for="textcorreo">Correo</label>
                                    <input type="text" class="form-control" id="textcorreo" name="textcorreo" required>
                                </div>
                                <div class="form-group">
                                    <label for="texttelefono">Telefono</label>
                                    <input type="password" class="form-control" id="texttelefono" name="texttelefono" required>
                                </div>
                                <div class="text-center">
                                    <br>
                                    <button type="submit" class="btn btn-primary">Ingresar</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
