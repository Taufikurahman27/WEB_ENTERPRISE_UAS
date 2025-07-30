<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String id = request.getParameter("id");
    String nama = request.getParameter("nama");
    String email = request.getParameter("email");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db_nugas", "root", "");

        // Gunakan nama tabel yang benar yaitu 'user'
        String sql = "UPDATE user SET nama = ?, email = ? WHERE id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, nama);
        ps.setString(2, email);
        ps.setInt(3, Integer.parseInt(id));
        ps.executeUpdate();

        conn.close();

        response.sendRedirect("data-register.jsp");  // kembali ke halaman data user
    } catch (Exception e) {
        out.println("Gagal update: " + e.getMessage());
    }
%>
