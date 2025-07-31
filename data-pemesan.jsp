<%@ page import="java.sql.*, java.text.NumberFormat, java.util.Locale" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    String user = (String) session.getAttribute("user");
    if (user == null || !"pikkk".equals(user)) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Data Pemesan</title>
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            display: flex;
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            background-color: #f1f5fc;
        }
        .sidebar {
            width: 240px;
            background-color: #5b3e2f;
            color: #fff8e1;
            height: 100vh;
            padding: 20px;
            position: fixed;
        }
        .sidebar h4 {
            font-weight: bold;
            margin-bottom: 30px;
            color: #fdd835;
        }
        .sidebar a {
            display: block;
            color: #fff8e1;
            padding: 10px;
            margin: 5px 0;
            text-decoration: none;
            border-radius: 5px;
        }
        .sidebar a:hover {
            background-color: #7b5745;
        }
        .sidebar a.logout {
            color: #ff4d4d;
        }
        .sidebar a.logout:hover {
            background-color: #c62828;
            color: white;
        }
        .sidebar i {
            margin-right: 10px;
        }
        .content {
            margin-left: 250px;
            padding: 30px;
            width: 100%;
        }
        .btn-group {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }
    </style>
</head>
<body>

<!-- Sidebar -->
<div class="sidebar">
    <h4>MUSEUM</h4>
    <a href="dashboard.jsp"><i class="fas fa-home"></i> Home</a>
    <a href="data-register.jsp"><i class="fas fa-users"></i> Data Register</a>
    <a href="data-barang.jsp"><i class="fas fa-plus"></i> Data Barang</a>
    <a href="data-pemesan.jsp"><i class="fas fa-clock"></i> Riwayat Pesanan</a>
    <a href="logout.jsp" class="logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
</div>

<!-- Main Content -->
<div class="content">
    <h2 class="mb-4">Riwayat Pemesanan</h2>

    <table class="table table-bordered table-striped table-hover">
        <thead class="table-dark">
            <tr>
                <th>No</th>
                <th>Nama User</th>
                <th>Produk</th>
                <th>Harga</th>
                <th>Quantity</th>
                <th>Total</th>
                <th>Alamat</th>
                <th>Metode</th>
                <th>Promo</th>
                <th>Ongkir</th>
                <th>Tanggal</th>
                <th>Status</th>
                <th>Aksi</th>
            </tr>
        </thead>
        <tbody>
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db_nugas", "root", "");

                String sql = "SELECT * FROM transaksi ORDER BY tanggal DESC";
                ps = conn.prepareStatement(sql);
                rs = ps.executeQuery();

                int no = 1;
                NumberFormat nf = NumberFormat.getCurrencyInstance(new Locale("id", "ID"));

                while (rs.next()) {
                    int id = rs.getInt("id");
                    String namaUser = rs.getString("user");
                    String produk = rs.getString("produk");
                    int harga = rs.getInt("harga");
                    int quantity = rs.getInt("quantity");
                    int total = rs.getInt("total_harga");
                    String alamat = rs.getString("alamat");
                    String metode = rs.getString("metode");
                    String promo = rs.getString("promo");
                    int ongkir = rs.getInt("ongkir");
                    Timestamp tanggal = rs.getTimestamp("tanggal");
                    String status = rs.getString("status");
        %>
            <tr>
                <td><%= no++ %></td>
                <td><%= namaUser %></td>
                <td><%= produk %></td>
                <td><%= nf.format(harga) %></td>
                <td><%= quantity %></td>
                <td><%= nf.format(total) %></td>
                <td><%= alamat %></td>
                <td><%= metode %></td>
                <td><%= promo != null ? promo : "-" %></td>
                <td><%= nf.format(ongkir) %></td>
                <td><%= tanggal %></td>
                <td><%= status %></td>
                <td>
                    <div class="btn-group">
                        <!-- Tombol Ubah Status -->
                        <form method="post" action="UpdateStatusServlet" style="display:inline;">
                            <input type="hidden" name="id" value="<%= id %>">
                            <input type="hidden" name="status" value="Sukses">
                            <button class="btn btn-success btn-sm" onclick="return confirm('Tandai sebagai sukses?')">Sukses</button>
                        </form>
                        <form method="post" action="UpdateStatusServlet" style="display:inline;">
                            <input type="hidden" name="id" value="<%= id %>">
                            <input type="hidden" name="status" value="Dibatalkan">
                            <button class="btn btn-danger btn-sm" onclick="return confirm('Batalkan pesanan?')">Batalkan</button>
                        </form>

                        <!-- Tombol Export JSON -->
                        <form method="get" action="ExportJSONServlet" target="_blank" style="display:inline;">
                            <input type="hidden" name="id" value="<%= id %>">
                            <button class="btn btn-primary btn-sm"><i class="fas fa-file-code"></i> JSON</button>
                        </form>

                        <!-- Tombol Modal PDF -->
                        <button type="button" class="btn btn-secondary btn-sm" data-bs-toggle="modal" data-bs-target="#modalDetail<%= id %>">
                            <i class="fas fa-file-pdf"></i> PDF
                        </button>
                    </div>

                    <!-- Modal Detail PDF -->
                    <div class="modal fade" id="modalDetail<%= id %>" tabindex="-1" aria-labelledby="modalLabel<%= id %>" aria-hidden="true">
                      <div class="modal-dialog modal-lg modal-dialog-scrollable">
                        <div class="modal-content">
                          <div class="modal-header">
                            <h5 class="modal-title" id="modalLabel<%= id %>">Detail Pemesanan</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                          </div>
                          <div class="modal-body">
                            <p><strong>Nama User:</strong> <%= namaUser %></p>
                            <p><strong>Produk:</strong> <%= produk %></p>
                            <p><strong>Harga:</strong> <%= nf.format(harga) %></p>
                            <p><strong>Quantity:</strong> <%= quantity %></p>
                            <p><strong>Total Harga:</strong> <%= nf.format(total) %></p>
                            <p><strong>Alamat:</strong> <%= alamat %></p>
                            <p><strong>Metode Pembayaran:</strong> <%= metode %></p>
                            <p><strong>Promo:</strong> <%= promo != null ? promo : "-" %></p>
                            <p><strong>Ongkir:</strong> <%= nf.format(ongkir) %></p>
                            <p><strong>Tanggal:</strong> <%= tanggal %></p>
                            <p><strong>Status:</strong> <%= status %></p>
                          </div>
                          <div class="modal-footer">
                            <a href="ExportPDFServlet?id=<%= id %>" target="_blank" class="btn btn-primary">
                                <i class="fas fa-download"></i> Unduh PDF
                            </a>
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Tutup</button>
                          </div>
                        </div>
                      </div>
                    </div>
                </td>
            </tr>
        <%
                }
            } catch (Exception e) {
                out.println("<tr><td colspan='13'>Gagal: " + e.getMessage() + "</td></tr>");
            } finally {
                if (rs != null) try { rs.close(); } catch (Exception e) {}
                if (ps != null) try { ps.close(); } catch (Exception e) {}
                if (conn != null) try { conn.close(); } catch (Exception e) {}
            }
        %>
        </tbody>
    </table>
</div>

<!-- Bootstrap JS untuk modal -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
