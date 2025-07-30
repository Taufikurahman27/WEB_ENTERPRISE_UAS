<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String id = request.getParameter("id");

    try {
        // Membuat koneksi ke database
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db_nugas", "root", "");

        // Query untuk menghapus pengguna berdasarkan ID
        String query = "DELETE FROM users WHERE id = ?";
        PreparedStatement ps = conn.prepareStatement(query);
        ps.setInt(1, Integer.parseInt(id));

        // Eksekusi query
        int rowsAffected = ps.executeUpdate();

        // Menutup koneksi
        conn.close();

        // Mengarahkan ke halaman data-register.jsp setelah data berhasil dihapus
        if (rowsAffected > 0) {
            response.sendRedirect("data-register.jsp");  // Redirect ke halaman utama setelah penghapusan berhasil
        } else {
            out.println("Gagal menghapus data. Pengguna tidak ditemukan.");
        }
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
<!-- Tombol Kembali ke Dashboard -->
<a href="dashboard.jsp" class="btn btn-info">Kembali ke Dashboard</a>