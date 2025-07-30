<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String id = request.getParameter("id");
    String nama = request.getParameter("nama");
    String email = request.getParameter("email");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db_nugas", "root", "");
        PreparedStatement ps = conn.prepareStatement("SELECT * FROM users WHERE id = ?");
        ps.setInt(1, Integer.parseInt(id));
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            nama = rs.getString("nama");
            email = rs.getString("email");
        }
        conn.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit User</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="p-4">
    <h2>Edit Data</h2>
    <form action="update-user.jsp" method="post">
        <input type="hidden" name="id" value="<%= id %>">
        <div class="mb-3">
            <label>Nama</label>
            <input type="text" name="nama" class="form-control" value="<%= nama %>" required>
        </div>
        <div class="mb-3">
            <label>Email</label>
            <input type="email" name="email" class="form-control" value="<%= email %>" required>
        </div>
        <button type="submit" class="btn btn-primary">Simpan</button>
        <a href="data-register.jsp" class="btn btn-secondary">Batal</a>
        <!-- Tombol Kembali ke Dashboard -->
        <a href="dashboard.jsp" class="btn btn-info">Kembali ke Dashboard</a>
    </form>
</body>
</html>