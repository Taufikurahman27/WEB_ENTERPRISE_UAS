<%@ page import="java.sql.*, java.text.NumberFormat, java.util.Locale" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    String idStr = request.getParameter("id");
    if (idStr == null || idStr.isEmpty()) {
        out.println("<p>ID produk tidak ditemukan.</p>");
        return;
    }

    int id = Integer.parseInt(idStr);

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db_nugas", "root", "");

        String sql = "SELECT * FROM produk WHERE id = ?";
        ps = conn.prepareStatement(sql);
        ps.setInt(1, id);
        rs = ps.executeQuery();

        if (rs.next()) {
            String namaProduk = rs.getString("nama");
            int harga = rs.getInt("harga");
            int stok = rs.getInt("stock");

            NumberFormat rupiah = NumberFormat.getCurrencyInstance(new Locale("id", "ID"));
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Checkout</title>
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <script src="js/bootstrap.bundle.min.js"></script>
    <script>
        window.onload = function() {
            const modal = new bootstrap.Modal(document.getElementById("checkoutModal"));
            modal.show();
        }
    </script>
</head>
<body class="bg-light">

<!-- Modal Checkout -->
<div class="modal fade" id="checkoutModal" tabindex="-1" aria-labelledby="checkoutModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form method="post" action="ProsesCheckoutServlet">
                <input type="hidden" name="from" value="direct">
                <input type="hidden" name="id_produk" value="<%= id %>">
                <div class="modal-header">
                    <h5 class="modal-title">Checkout Produk</h5>
                    <a href="landingpage.jsp" class="btn-close"></a>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label>Nama Produk:</label>
                        <input type="text" class="form-control" value="<%= namaProduk %>" readonly>
                    </div>
                    <div class="mb-3">
                        <label>Harga:</label>
                        <input type="text" class="form-control" value="<%= rupiah.format(harga) %>" readonly>
                    </div>
                    <div class="mb-3">
                        <label>Jumlah:</label>
                        <input type="number" name="jumlah" class="form-control" value="1" min="1" max="<%= stok %>" required>
                    </div>
                    <div class="mb-3">
                        <label>Alamat Pengiriman:</label>
                        <textarea name="alamat" class="form-control" required></textarea>
                    </div>
                    <div class="mb-3">
                        <label>Metode Pembayaran:</label>
                        <select name="metode" class="form-control" required>
                            <option value="">Pilih</option>
                            <option value="Transfer Bank">Transfer Bank</option>
                            <option value="COD">Bayar di Tempat</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label>Promo (Opsional):</label>
                        <input type="text" name="promo" class="form-control">
                    </div>
                    <div class="mb-3">
                        <label>Ongkir:</label>
                        <input type="number" name="ongkir" class="form-control" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-success">Beli Sekarang</button>
                    <a href="landingpage.jsp" class="btn btn-secondary">Kembali</a>
                </div>
            </form>
        </div>
    </div>
</div>

</body>
</html>
<%
        } else {
            out.println("<p>Produk tidak ditemukan.</p>");
        }
    } catch (Exception e) {
        out.println("<p style='color:red;'>Terjadi kesalahan: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
%>
