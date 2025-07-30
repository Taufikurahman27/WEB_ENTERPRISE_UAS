<%@ page import="java.io.*,java.sql.*" %>
<%@ page import="javax.servlet.http.Part" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");

    String jdbcURL = "jdbc:mysql://localhost:3306/db_nugas";
    String dbUser = "root"; // sesuaikan
    String dbPass = ""; // sesuaikan

    // Lokasi folder upload di server (pastikan folder ini ada dan bisa diakses)
    String uploadDir = application.getRealPath("") + File.separator + "uploads";

    // Buat folder uploads jika belum ada
    File uploadFolder = new File(uploadDir);
    if (!uploadFolder.exists()) {
        uploadFolder.mkdirs();
    }

    // Ambil parameter dari form
    String nama = request.getParameter("nama");
    String hargaStr = request.getParameter("harga");
    String ratingStr = request.getParameter("rating");
    String terjualStr = request.getParameter("terjual");

    Part filePart = request.getPart("gambar"); // input type file name="gambar"

    String fileName = "";
    if (filePart != null) {
        // Dapatkan nama file asli
        String submittedFileName = filePart.getSubmittedFileName();
        // Buat nama file unik dengan timestamp supaya tidak tertimpa
        fileName = System.currentTimeMillis() + "_" + submittedFileName;
        // Simpan file ke folder uploads
        filePart.write(uploadDir + File.separator + fileName);
    }

    if (nama == null || hargaStr == null || ratingStr == null || terjualStr == null || fileName.isEmpty()) {
%>
    <script>
        alert('Semua data wajib diisi dan file gambar harus dipilih!');
        window.history.back();
    </script>
<%
        return;
    }

    int harga = 0;
    double rating = 0;
    int terjual = 0;
    try {
        harga = Integer.parseInt(hargaStr);
        rating = Double.parseDouble(ratingStr);
        terjual = Integer.parseInt(terjualStr);
    } catch (Exception e) {
%>
    <script>
        alert('Format harga, rating, atau terjual tidak valid!');
        window.history.back();
    </script>
<%
        return;
    }

    Connection conn = null;
    PreparedStatement ps = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcURL, dbUser, dbPass);

        String sql = "INSERT INTO produk (nama, gambar, harga, rating, terjual) VALUES (?, ?, ?, ?, ?)";
        ps = conn.prepareStatement(sql);
        ps.setString(1, nama);
        ps.setString(2, fileName);
        ps.setInt(3, harga);
        ps.setDouble(4, rating);
        ps.setInt(5, terjual);

        int result = ps.executeUpdate();

        if (result > 0) {
%>
            <script>
                alert('Produk berhasil ditambahkan!');
                window.location = "data-produk.jsp";
            </script>
<%
        } else {
%>
            <script>
                alert('Gagal menambahkan produk!');
                window.history.back();
            </script>
<%
        }

    } catch (Exception e) {
%>
        <script>
            alert('Error: <%= e.getMessage() %>');
            window.history.back();
        </script>
<%
    } finally {
        try { if (ps != null) ps.close(); } catch(Exception e) {}
        try { if (conn != null) conn.close(); } catch(Exception e) {}
    }
%>