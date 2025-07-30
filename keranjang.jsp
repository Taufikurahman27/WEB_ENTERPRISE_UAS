<%@ page import="java.sql.*, java.text.NumberFormat, java.util.Locale" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    String user = (String) session.getAttribute("user");
    if (user == null) {
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
    <title>Keranjang Belanja</title>
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <script src="js/bootstrap.bundle.min.js"></script>
    <style>
        body {
            background-color: #f4efe6; /* krem muda */
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #3e2f1c; /* coklat tua */
        }
        .container {
            background-color: #fff8f0;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 0 10px rgba(62, 47, 28, 0.2);
        }
        h3 {
            color: #5e3d1c; /* coklat antik */
        }
        table {
            background-color: #fffdf8;
        }
        th {
            background-color: #cbb27c; /* emas antik */
            color: #3e2f1c;
        }
        .btn-success {
            background-color: #8d6e45; /* coklat keemasan */
            border-color: #8d6e45;
        }
        .btn-success:hover {
            background-color: #a88450;
            border-color: #a88450;
        }
        .btn-secondary {
            background-color: #c4b69f;
            border-color: #c4b69f;
        }
        .modal-content {
            background-color: #fefaf3;
        }
        .form-label {
            color: #5e3d1c;
        }
    </style>
    <script>
        function openCheckoutModal() {
            const selected = document.querySelectorAll("input[name='produk']:checked");
            if (selected.length === 0) {
                alert("Pilih minimal satu produk untuk checkout!");
                return;
            }

            document.getElementById("ongkir").value = 10000;
            const modal = new bootstrap.Modal(document.getElementById("checkoutModal"));
            modal.show();
        }
    </script>
</head>
<body>
<div class="container mt-5">
    <h3>Keranjang Anda</h3>
    <form action="ProsesCheckoutServlet" method="post">
    <table class="table table-bordered mt-3">
        <thead>
            <tr>
                <th>Pilih</th>
                <th>No</th>
                <th>Nama Produk</th>
                <th>Jumlah</th>
                <th>Total Harga</th>
                <th>Tanggal</th>
            </tr>
        </thead>
        <tbody>
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db_nugas", "root", "");

                String sql = "SELECT k.*, p.nama AS judul FROM keranjang k JOIN produk p ON k.id_produk = p.id WHERE k.user = ?";
                ps = conn.prepareStatement(sql);
                ps.setString(1, user);
                rs = ps.executeQuery();

                int no = 1;
                NumberFormat rupiah = NumberFormat.getCurrencyInstance(new Locale("id", "ID"));
                while (rs.next()) {
                    int idKeranjang = rs.getInt("id");
                    String namaProduk = rs.getString("judul");
                    int jumlah = rs.getInt("jumlah");
                    int totalHarga = rs.getInt("total_harga");
                    Timestamp tanggal = rs.getTimestamp("tanggal");
        %>
            <tr>
                <td><input type="checkbox" name="produk" value="<%= idKeranjang %>"></td>
                <td><%= no++ %></td>
                <td><%= namaProduk %></td>
                <td><%= jumlah %></td>
                <td><%= rupiah.format(totalHarga) %></td>
                <td><%= tanggal != null ? tanggal : "-" %></td>
            </tr>
        <%
                }
            } catch (Exception e) {
                out.println("<tr><td colspan='6'>Error: " + e.getMessage() + "</td></tr>");
            } finally {
                if (rs != null) try { rs.close(); } catch (Exception e) {}
                if (ps != null) try { ps.close(); } catch (Exception e) {}
                if (conn != null) try { conn.close(); } catch (Exception e) {}
            }
        %>
        </tbody>
    </table>

    <button type="button" class="btn btn-success" onclick="openCheckoutModal()">Checkout</button>
    <a href="landingpage.jsp" class="btn btn-secondary mt-2">Kembali ke Katalog</a>

    <div class="modal fade" id="checkoutModal" tabindex="-1" aria-labelledby="checkoutModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title">Konfirmasi Checkout</h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label class="form-label">Alamat Pengiriman:</label>
                    <textarea class="form-control" name="alamat" rows="2" required></textarea>
                </div>
                <div class="mb-3">
                    <label class="form-label">Metode Pembayaran:</label>
                    <select class="form-control" name="metode" required>
                        <option value="Transfer Bank">Transfer Bank</option>
                        <option value="COD">COD</option>
                        <option value="QRIS">QRIS</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label">Kode Promo (Opsional):</label>
                    <input type="text" name="promo" class="form-control">
                </div>
                <div class="mb-3">
                    <label class="form-label">Ongkos Kirim (Rp):</label>
                    <input type="number" id="ongkir" name="ongkir" class="form-control" required>
                </div>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-success">Proses Checkout</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
            </div>
        </div>
      </div>
    </div>
    </form>
</div>
</body>
</html>
