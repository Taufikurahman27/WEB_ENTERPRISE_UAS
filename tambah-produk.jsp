<%@ page import="java.sql.*, java.io.*, jakarta.servlet.http.Part" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%
    request.setCharacterEncoding("UTF-8");

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            String nama     = request.getParameter("nama");
            float  rating   = Float.parseFloat(request.getParameter("rating"));
            int    harga    = Integer.parseInt(request.getParameter("harga"));
            int    terjual  = Integer.parseInt(request.getParameter("terjual"));
            int    stock    = Integer.parseInt(request.getParameter("stock"));
            
            Part part = request.getPart("gambar");

            if (part != null && part.getSize() > 0) {
                // Buat folder /gambar jika belum ada
                String fileName = new File(part.getSubmittedFileName()).getName();
                String uploadPath = application.getRealPath("/") + "gambar";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();

                // Simpan file
                String filePath = uploadPath + File.separator + fileName;
                part.write(filePath);

                // Simpan ke database
                Class.forName("com.mysql.cj.jdbc.Driver"); // Penting!
                try (Connection cn = DriverManager.getConnection(
                            "jdbc:mysql://localhost:3306/db_nugas", "root", "");
                     PreparedStatement ps = cn.prepareStatement(
                        "INSERT INTO produk (nama, rating, harga, terjual, stock, gambar) VALUES (?, ?, ?, ?, ?, ?)")) {

                    ps.setString(1, nama);
                    ps.setFloat(2, rating);
                    ps.setInt(3, harga);
                    ps.setInt(4, terjual);
                    ps.setInt(5, stock);
                    ps.setString(6, "gambar/" + fileName); // Simpan relative path

                    ps.executeUpdate();
                    response.sendRedirect("data-barang.jsp?success=Produk+berhasil+ditambah");
                    return;
                }
            } else {
                out.println("<p style='color:red'>Gambar wajib di-upload!</p>");
            }
        } catch (Exception e) {
            out.println("<p style='color:red'>Terjadi error: " + e.getMessage() + "</p>");
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tambah Produk</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container mt-4">
    <h2>Tambah Produk</h2>
    <form method="post" enctype="multipart/form-data">
        <div class="mb-3">
            <label>Nama:</label>
            <input type="text" name="nama" class="form-control" required>
        </div>
        <div class="mb-3">
            <label>Rating:</label>
            <input type="number" step="0.1" name="rating" class="form-control" required>
        </div>
        <div class="mb-3">
            <label>Harga:</label>
            <input type="number" name="harga" class="form-control" required>
        </div>
        <div class="mb-3">
            <label>Terjual:</label>
            <input type="number" name="terjual" class="form-control" required>
        </div>
        <div class="mb-3">
            <label>Stock:</label>
            <input type="number" name="stock" class="form-control" required>
        </div>
        <div class="mb-3">
            <label>Gambar:</label>
            <input type="file" name="gambar" accept="image/*" class="form-control" required>
        </div>
        <button type="submit" class="btn btn-success">Tambah</button>
    </form>
</body>
</html>
