<%@ page import="java.io.*, java.sql.*, javax.servlet.*, javax.servlet.http.*, javax.servlet.annotation.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="org.apache.commons.io.FilenameUtils" %>
<%
    request.setCharacterEncoding("UTF-8");
    String id = request.getParameter("id");
    String judul = request.getParameter("judul");
    String deskripsi = request.getParameter("deskripsi");
    float rating = Float.parseFloat(request.getParameter("rating"));
    int harga = Integer.parseInt(request.getParameter("harga"));
    int terjual = Integer.parseInt(request.getParameter("terjual"));

    Part filePart = request.getPart("gambar");
    String fileName = FilenameUtils.getName(filePart.getSubmittedFileName());
    String uploadPath = application.getRealPath("") + "gambar";

    File uploadDir = new File(uploadPath);
    if (!uploadDir.exists()) uploadDir.mkdir();

    if (fileName != null && !fileName.isEmpty()) {
        filePart.write(uploadPath + File.separator + fileName);
    }

    Connection conn = null;
    PreparedStatement ps = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db_nugas", "root", "");
        String sql;
        if (fileName != null && !fileName.isEmpty()) {
            sql = "UPDATE produk SET judul=?, deskripsi=?, rating=?, harga=?, terjual=?, gambar=? WHERE id=?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, judul);
            ps.setString(2, deskripsi);
            ps.setFloat(3, rating);
            ps.setInt(4, harga);
            ps.setInt(5, terjual);
            ps.setString(6, fileName);
            ps.setString(7, id);
        } else {
            sql = "UPDATE produk SET judul=?, deskripsi=?, rating=?, harga=?, terjual=? WHERE id=?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, judul);
            ps.setString(2, deskripsi);
            ps.setFloat(3, rating);
            ps.setInt(4, harga);
            ps.setInt(5, terjual);
            ps.setString(6, id);
        }
        ps.executeUpdate();
        response.sendRedirect("data-barang.jsp");
    } catch (Exception e) {
        out.println("Gagal update data: " + e.getMessage());
    } finally {
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
%>
