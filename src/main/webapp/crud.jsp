<%@page import="java.util.List"%>
<%@ page import="org.uv.crudalumnos.DAOAlumno" %>
<%@ page import="org.uv.crudalumnos.Alumno" %>

<%-- 
    Document   : index
    Created on : 24 sep. 2023, 9:48:34 p. m.
    Author     : zarcorp
--%>

<%
// Verificar si el usuario ha iniciado sesión (puedes mantener esta parte si la usas)
    if (session.getAttribute("usuario") == null) {
      response.sendRedirect("index.jsp"); // Redireccionar al usuario a la página de inicio de sesión si no ha iniciado sesión
    return;
    }

    String action = request.getParameter("action");

    if ("logout".equals(action)) {
        session.invalidate();
        response.sendRedirect("index.jsp");
        return;
    }

    DAOAlumno dao = new DAOAlumno();

    if ("insert".equals(action)) {
        // Obtener los valores del formulario
        String nombre = request.getParameter("nombre");
        String direccion = request.getParameter("direccion");
        String telefono = request.getParameter("telefono");
        String correo = request.getParameter("correo");

        // Crear un objeto Alumno con los datos del formulario
        Alumno alumno = new Alumno();
        alumno.setNombre(nombre);
        alumno.setDireccion(direccion);
        alumno.setTelefono(telefono);
        alumno.setCorreo(correo);

        // Insertar el alumno en la base de datos
        dao.create(alumno);
    }

    if ("update".equals(action)) {
        int id = Integer.parseInt(request.getParameter("id"));
        String nombre = request.getParameter("nombre");
        String direccion = request.getParameter("direccion");
        String telefono = request.getParameter("telefono");
        String correo = request.getParameter("correo");

        Alumno alumno = new Alumno();
        alumno.setId(id);
        alumno.setNombre(nombre);
        alumno.setDireccion(direccion);
        alumno.setTelefono(telefono);
        alumno.setCorreo(correo);

        // Actualizar el alumno en la base de datos
        dao.update(id, alumno);
    }

    List<Alumno> alumnos = dao.findAll();
    Alumno alumnoEdit = null;

    if ("edit".equals(action)) {
        int id = Integer.parseInt(request.getParameter("id"));
        alumnoEdit = dao.findById(id);
    }

    if ("delete".equals(action)) {
        int id = Integer.parseInt(request.getParameter("id"));
        dao.delete(id);
        response.sendRedirect(request.getRequestURI());

    }

%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/css/bootstrap.min.css"
              integrity="sha384-0evHe/X+R7YkIZDRvuzKMRqM+OrBnVFBL6DOitfPri4tjfHxaWutUpFmBp4vmVor" crossorigin="anonymous" />
    </head>
    <body>
        <div class="container">
            <div class="row justify-content-center p-5">
                <div class="col-sm-6">
                    <h1>Alta Alumnos Formulario</h1>
                    <form method="post" action="crud.jsp">
                        <input type="hidden" name="action" value="<%= (alumnoEdit != null) ? "update" : "insert"%>">
                        <input type="hidden" name="id" value="<%= (alumnoEdit != null) ? alumnoEdit.getId() : ""%>">
                        <input type="text" class="form-control" name="nombre" value="<%= (alumnoEdit != null) ? alumnoEdit.getNombre() : ""%>" placeholder="Nombre" required>
                        <input type="text" class="form-control" name="direccion" value="<%= (alumnoEdit != null) ? alumnoEdit.getDireccion() : ""%>" placeholder="Dirección" required>
                        <input type="text" class="form-control" name="telefono" value="<%= (alumnoEdit != null) ? alumnoEdit.getTelefono() : ""%>" placeholder="Teléfono" required>
                        <input type="text" class="form-control" name="correo" value="<%= (alumnoEdit != null) ? alumnoEdit.getCorreo() : ""%>" placeholder="Correo" required>
                        <input type="submit" class="btn btn-primary" value="<%= (alumnoEdit != null) ? "Actualizar" : "Guardar"%>">
                    </form>             
                    <% if (alumnos != null) { %>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Clave</th>
                                <th>Nombre</th>
                                <th>Dirección</th>
                                <th>Correo</th>
                                <th>Teléfono</th>
                                <th>Opciones</th>
                            </tr>
                        </thead>
                        <tbody id="tbody">
                            <% for (Alumno alumno : alumnos) {%>
                            <tr>
                                <td>
                                    <a href="index.jsp?action=edit&id=<%= alumno.getId()%>"><%= alumno.getId()%></a>                                    
                                </td>
                                <td>
                                    <%= alumno.getNombre()%>
                                </td>
                                <td>
                                    <%= alumno.getDireccion()%>
                                </td>
                                <td>
                                    <%= alumno.getCorreo()%>
                                </td>
                                <td>
                                    <%= alumno.getTelefono()%>
                                </td>
                                <td>
                                    <a class="btn btn-danger" href="#" onclick="confirmDelete(<%= alumno.getId()%>)">Eliminar</a>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <% }%>
                    <% } else { %>
                    <p>No se encontraron alumnos.</p>
                    <% }%>
                </div>
            </div>
            </<div>
                </body>
                <script>
                    function confirmDelete(id) {
                        if (confirm("¿Estás seguro de que deseas eliminar este alumno?")) {
                            // Si el usuario confirma la eliminación, redirige a la página de eliminación
                            window.location.href = "index.jsp?action=delete&id=" + id;
                        }
                    }
                </script>

                </html>
