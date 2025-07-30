<%@page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%  /* Jalankan hanya bila datang dari form POST */
    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        response.sendRedirect("login.jsp");
        return;
    }

    String email    = request.getParameter("email");
    String password = request.getParameter("password");

    if (email == null || password == null ||
        email.trim().isEmpty() || password.trim().isEmpty()) {
        response.sendRedirect("login.jsp?pesan=gagal");
        return;
    }

    boolean ok = false;
    String nama = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        try (Connection conn = DriverManager.getConnection(
                 "jdbc:mysql://localhost:3306/db_nugas?useSSL=false&serverTimezone=Asia/Jakarta",
                 "root", "");                              // ganti bila root pakai password
             PreparedStatement ps = conn.prepareStatement(
                 "SELECT nama FROM user WHERE email=? AND password=?")) {

            ps.setString(1, email.trim());
            ps.setString(2, password.trim());              // hash‑kan bila kolom menyimpan hash

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ok   = true;
                    nama = rs.getString("nama");
                }
            }
        }
    } catch (Exception ex) {
        ex.printStackTrace();   // log di console saja
    }

    if (ok) {
        session.setAttribute("user_email", email);
        session.setAttribute("user", nama);
        response.sendRedirect("landingpage.jsp");
    } else {
        response.sendRedirect("login.jsp?pesan=gagal");
    }
%>
