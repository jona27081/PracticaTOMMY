/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package org.uv.crudalumnos;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DAOAlumno implements IDAOGeneral<Alumno, Integer> {

    @Override
    public Alumno create(Alumno p) {
        ConexionDB cx = ConexionDB.getInstance();
        TransactionDB tbd = new TransactionDB<Alumno>(p) {
            @Override
            public boolean execute(Connection con) {
                try ( PreparedStatement psm = con.prepareStatement("INSERT INTO alumnos(id, nombre, direccion, telefono, correo) VALUES (?, ?, ?, ?, ?)")) {
                    psm.setInt(1, p.getId());
                    psm.setString(2, p.getNombre());
                    psm.setString(3, p.getDireccion());
                    psm.setString(4, p.getTelefono());
                    psm.setString(5, p.getCorreo());
                    psm.execute();
                    return true;
                } catch (SQLException ex) {
                    Logger.getLogger(DAOAlumno.class.getName()).log(Level.SEVERE, "Error al crear alumno", ex);
                    return false;
                }
            }
        };
        cx.execute(tbd);
        return p;
    }

    @Override
    public boolean delete(final Integer id) {
        ConexionDB cx = ConexionDB.getInstance();
        TransactionDB tbd = new TransactionDB<Integer>(id) {
            @Override
            public boolean execute(Connection con) {
                try ( PreparedStatement psm = con.prepareStatement("DELETE FROM alumnos WHERE id = ?")) {
                    psm.setInt(1, id);
                    psm.execute();
                    return true;
                } catch (SQLException ex) {
                    Logger.getLogger(DAOAlumno.class.getName()).log(Level.SEVERE, "Error al eliminar alumno", ex);
                    return false;
                }
            }
        };

        boolean resp = cx.execute(tbd);
        if (resp) {
            Logger.getLogger(DAOAlumno.class.getName()).log(Level.INFO, "Alumno eliminado");
            return true;
        } else {
            Logger.getLogger(DAOAlumno.class.getName()).log(Level.INFO, "Error al eliminar alumno");
            return false;
        }
    }

    @Override
    public Alumno update(final Integer id, Alumno p) {
        ConexionDB cx = ConexionDB.getInstance();
        TransactionDB tbd = new TransactionDB<Alumno>(p) {
            @Override
            public boolean execute(Connection con) {
                try ( PreparedStatement psm = con.prepareStatement("UPDATE alumnos SET nombre=?, direccion=?, telefono=?, correo=? WHERE id=?")) {
                    psm.setString(1, p.getNombre());
                    psm.setString(2, p.getDireccion());
                    psm.setString(3, p.getTelefono());
                    psm.setString(4, p.getCorreo());
                    psm.setInt(5, id);
                    psm.execute();
                    return true;
                } catch (SQLException ex) {
                    Logger.getLogger(DAOAlumno.class.getName()).log(Level.SEVERE, "Error al actualizar alumno", ex);
                    return false;
                }
            }
        };
        cx.execute(tbd);
        return p;
    }

    @Override
    public List<Alumno> findAll() {
        final List<Alumno> alumnos = new ArrayList<>();
        ConexionDB cx = ConexionDB.getInstance();
        TransactionDB tbd = new TransactionDB<List<Alumno>>(alumnos) {
            @Override
            public boolean execute(Connection con) {
                try ( PreparedStatement psm = con.prepareStatement("SELECT * FROM alumnos");  ResultSet rs = psm.executeQuery()) {

                    while (rs.next()) {
                        Alumno alumno = new Alumno();
                        alumno.setId(rs.getInt("id"));
                        alumno.setNombre(rs.getString("nombre"));
                        alumno.setDireccion(rs.getString("direccion"));
                        alumno.setTelefono(rs.getString("telefono"));
                        alumno.setCorreo(rs.getString("correo"));
                        alumnos.add(alumno);
                    }
                    return true;
                } catch (SQLException ex) {
                    Logger.getLogger(DAOAlumno.class.getName()).log(Level.SEVERE, "Error al obtener la lista de alumnos", ex);
                    return false;
                } catch (NullPointerException ex) {
                    Logger.getLogger(DAOAlumno.class.getName()).log(Level.SEVERE, "NullPointerException en DAOAlumno", ex);
                    return false;
                }
            }
        };
        boolean resp = cx.execute(tbd);
        if (resp) {
            Logger.getLogger(DAOAlumno.class.getName()).log(Level.INFO, "Lista de alumnos obtenida");
            return alumnos;
        } else {
            Logger.getLogger(DAOAlumno.class.getName()).log(Level.INFO, "Error al obtener la lista de alumnos");
            return null;
        }
    }

    @Override
    public Alumno findById(final Integer id) {
        ConexionDB cx = ConexionDB.getInstance();
        Alumno p = new Alumno();
        TransactionDB tbd = new TransactionDB<Alumno>(p) {
            @Override
            public boolean execute(Connection con) {
                try ( PreparedStatement psm = con.prepareStatement("SELECT * FROM alumnos WHERE id = ?")) {
                    psm.setInt(1, id);
                    try ( ResultSet rs = psm.executeQuery()) {
                        if (rs.next()) {
                            p.setId(rs.getInt("id"));
                            p.setNombre(rs.getString("nombre"));
                            p.setDireccion(rs.getString("direccion"));
                            p.setTelefono(rs.getString("telefono"));
                            p.setCorreo(rs.getString("correo"));
                            return true;
                        } else {
                            Logger.getLogger(DAOAlumno.class.getName()).log(Level.SEVERE, "Alumno no encontrado");
                            return false;
                        }
                    }
                } catch (SQLException ex) {
                    Logger.getLogger(DAOAlumno.class.getName()).log(Level.SEVERE, "Error al obtener alumno por ID", ex);
                    return false;
                }
            }
        };

        boolean resp = cx.execute(tbd);
        if (resp) {
            return p;
        } else {
            return null;
        }
    }

    public Alumno login(final String correo, final String telefono) {
        ConexionDB cx = ConexionDB.getInstance();
        Alumno p = new Alumno();
        TransactionDB tbd = new TransactionDB<Alumno>(p) {
            @Override
            public boolean execute(Connection con) {
                try ( PreparedStatement psm = con.prepareStatement("SELECT * FROM alumnos WHERE correo = ? AND telefono = ?")) {
                    psm.setString(1, correo);
                    psm.setString(2, telefono);

                    try ( ResultSet rs = psm.executeQuery()) {
                        if (rs.next()) {
                            p.setId(rs.getInt("id"));
                            p.setNombre(rs.getString("nombre"));
                            p.setDireccion(rs.getString("direccion"));
                            p.setTelefono(rs.getString("telefono"));
                            p.setCorreo(rs.getString("correo"));
                            return true;
                        }  else {
                            Logger.getLogger(DAOAlumno.class.getName()).log(Level.SEVERE, "Alumno no encontrado");
                            return false;
                        }
                    }
                } catch (SQLException ex) {
                    Logger.getLogger(DAOAlumno.class.getName()).log(Level.SEVERE, "Error en el inicio de sesión", ex);
                    return false;
                }
            }
        };

        boolean resp = cx.execute(tbd);

        if (resp) {
            return p; // Devuelve el objeto Alumno si se encontró una coincidencia
        } else {
            return null; // Devuelve null si no se encontró una coincidencia o hubo un error
        }
    }

}
