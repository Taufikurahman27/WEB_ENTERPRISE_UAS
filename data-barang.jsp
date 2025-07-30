<%@ page import="java.sql.*, java.text.NumberFormat, java.util.Locale" %>
<%@ page import="java.io.*, jakarta.servlet.*, jakarta.servlet.http.*" %>
<%@ page import="org.apache.poi.xssf.usermodel.*, org.apache.poi.ss.usermodel.*, org.apache.poi.xwpf.usermodel.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page session="true" %>

<%
    String user = (String) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String action = request.getParameter("action");
    if ("exportExcel".equals(action)) {
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=produk.xlsx");

        XSSFWorkbook workbook = new XSSFWorkbook();
        XSSFSheet sheet = workbook.createSheet("Data Produk");

        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db_nugas", "root", "");
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM produk");

        XSSFRow header = sheet.createRow(0);
        header.createCell(0).setCellValue("ID");
        header.createCell(1).setCellValue("Nama");
        header.createCell(2).setCellValue("Gambar");
        header.createCell(3).setCellValue("Harga");
        header.createCell(4).setCellValue("Stok");

        int rowIndex = 1;
        while (rs.next()) {
            XSSFRow row = sheet.createRow(rowIndex++);
            row.createCell(0).setCellValue(rs.getInt("id"));
            row.createCell(1).setCellValue(rs.getString("nama"));
            row.createCell(2).setCellValue(rs.getString("gambar"));
            row.createCell(3).setCellValue(rs.getDouble("harga"));
            row.createCell(4).setCellValue(rs.getInt("stock"));
        }

        workbook.write(response.getOutputStream());
        workbook.close();
        rs.close(); stmt.close(); conn.close();
        return;
    } else if ("exportWord".equals(action)) {
        response.setContentType("application/vnd.openxmlformats-officedocument.wordprocessingml.document");
        response.setHeader("Content-Disposition", "attachment; filename=produk.docx");

        XWPFDocument doc = new XWPFDocument();
        XWPFParagraph para = doc.createParagraph();
        XWPFRun run = para.createRun();
        run.setText("Daftar Produk");
        run.setBold(true);
        run.setFontSize(16);

        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db_nugas", "root", "");
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM produk");

        while (rs.next()) {
            XWPFParagraph p = doc.createParagraph();
            XWPFRun r = p.createRun();
            r.setText(
                "ID: " + rs.getInt("id") +
                ", Nama: " + rs.getString("nama") +
                ", Gambar: " + rs.getString("gambar") +
                ", Harga: " + rs.getDouble("harga") +
                ", Stok: " + rs.getInt("stock")
            );
        }

        doc.write(response.getOutputStream());
        doc.close();
        rs.close(); stmt.close(); conn.close();
        return;
    }

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db_nugas", "root", "");
        String sql = "SELECT * FROM produk";
        ps = conn.prepareStatement(sql);
        rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Data Barang - MUSEUM</title>
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <script src="js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background-color: #e6f2ff; margin: 0; }
        .sidebar {
            width: 200px;
            background-color: #5b3e2f;
            color: #fff8e1;
            min-height: 100vh;
            padding: 20px;
            position: fixed;
        }
        .sidebar h2 { font-size: 18px; margin-bottom: 30px; color: #fdd835; }
        .sidebar ul { list-style-type: none; padding: 0; }
        .sidebar ul li { margin: 15px 0; }
        .sidebar ul li a {
            color: #fff8e1; text-decoration: none; display: flex; align-items: center; gap: 8px;
        }
        .sidebar ul li a:hover { color: #fdd835; }
        .sidebar .logout-link {
            margin-top: 30px; color: #ff4d4d; text-decoration: none; font-weight: bold;
            display: flex; align-items: center; gap: 8px;
        }
        .sidebar .logout-link:hover { color: #ff1a1a; }
        .main-content { margin-left: 240px; padding: 40px 30px; }
        h1 { font-size: 24px; color: #1e40af; }
        .btn-custom { background-color: #1e3a8a; color: white; }
        .btn-custom:hover { background-color: #3b82f6; }
        table th { background-color: #1e40af; color: white; }
        img { object-fit: cover; }
    </style>
</head>
<body>
<div class="sidebar">
    <h2>MUSEUM</h2>
    <ul>
        <li><a href="dashboard.jsp"><i class="fa fa-home"></i> Home</a></li>
        <li><a href="data-register.jsp"><i class="fa fa-users"></i> Data Register</a></li>
        <li><a href="data-barang.jsp"><i class="fa fa-box"></i> Data Barang</a></li>
        <li><a href="data-pemesan.jsp"><i class="fa fa-history"></i> Riwayat Pesanan</a></li>
    </ul>
    <a href="logout.jsp" class="logout-link"><i class="fa fa-sign-out-alt"></i> Logout</a>
</div>

<div class="main-content">
    <h1>Data Barang</h1>

    <!-- Tombol Export -->
    <form method="get" class="mb-3 d-inline">
        <button type="submit" name="action" value="exportExcel" class="btn btn-success btn-sm">
            <i class="fa fa-file-excel"></i> Export ke Excel
        </button>
        <button type="submit" name="action" value="exportWord" class="btn btn-primary btn-sm">
            <i class="fa fa-file-word"></i> Export ke Word
        </button>
    </form>

    <!-- Tombol Tambah -->
    <button class="btn btn-custom btn-sm mb-3 float-end" data-bs-toggle="modal" data-bs-target="#tambahModal">
        <i class="fa fa-plus"></i> Tambah Barang
    </button>

    <div class="clearfix"></div>

    <table class="table table-bordered table-striped">
        <thead>
        <tr>
            <th>ID</th>
            <th>Nama</th>
            <th>Gambar</th>
            <th>Rating</th>
            <th>Harga</th>
            <th>Terjual</th>
            <th>Stock</th>
            <th>Aksi</th>
        </tr>
        </thead>
        <tbody>
        <%
            NumberFormat rupiah = NumberFormat.getCurrencyInstance(new Locale("id", "ID"));
            while (rs.next()) {
                int id = rs.getInt("id");
        %>
        <tr>
            <td><%= id %></td>
            <td><%= rs.getString("nama") %></td>
            <td><img src="<%= rs.getString("gambar").startsWith("gambar/") ? rs.getString("gambar") : "gambar/" + rs.getString("gambar") %>" width="60" height="80" /></td>
            <td><%= rs.getFloat("rating") %></td>
            <td><%= rupiah.format(rs.getInt("harga")) %></td>
            <td><%= rs.getInt("terjual") %></td>
            <td><%= rs.getInt("stock") %></td>
            <td>
                <button class="btn btn-warning btn-sm"
                        onclick="isiFormEdit(<%= id %>, '<%= rs.getString("nama").replace("'", "\\'") %>', '<%= rs.getString("gambar") %>', <%= rs.getFloat("rating") %>, <%= rs.getInt("harga") %>, <%= rs.getInt("terjual") %>, <%= rs.getInt("stock") %>)"
                        data-bs-toggle="modal" data-bs-target="#editModal">
                    Edit
                </button>
                <a href="hapus-produk?id=<%= id %>" class="btn btn-danger btn-sm" onclick="return confirm('Yakin ingin menghapus produk ini?');">Hapus</a>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>
</div>

<!-- Include modal tambah & edit dari kode sebelumnya -->
<jsp:include page="modal-produk.jsp" />

<script>
    function isiFormEdit(id, nama, gambar, rating, harga, terjual, stock) {
        document.getElementById('editId').value = id;
        document.getElementById('editNama').value = nama;
        document.getElementById('editGambarLama').value = gambar;
        document.getElementById('editRating').value = rating;
        document.getElementById('editHarga').value = harga;
        document.getElementById('editTerjual').value = terjual;
        document.getElementById('editStock').value = stock;
    }
</script>
</body>
</html>

<%
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (ps != null) try { ps.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>
