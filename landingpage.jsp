<%@ page import="java.sql.*, java.text.NumberFormat, java.util.Locale" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    String user = (String) session.getAttribute("user");
    String email = (String) session.getAttribute("user_email");

    // Ambil email dari database jika session email kosong
    if (email == null && user != null) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection connEmail = DriverManager.getConnection("jdbc:mysql://localhost:3306/db_nugas", "root", "");
            PreparedStatement psEmail = connEmail.prepareStatement("SELECT email FROM user WHERE nama=? LIMIT 1");
            psEmail.setString(1, user);
            ResultSet rsEmail = psEmail.executeQuery();
            if (rsEmail.next()) {
                email = rsEmail.getString("email");
                session.setAttribute("user_email", email);
            }
            rsEmail.close();
            psEmail.close();
            connEmail.close();
        } catch (Exception e) {
            out.println("<script>alert('Gagal ambil email: " + e.getMessage() + "');</script>");
        }
    }

    // Proses ubah nama user
    String newName = request.getParameter("newName");
    if (newName != null && !newName.trim().isEmpty() && email != null) {
        Connection updateConn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            updateConn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db_nugas", "root", "");
            PreparedStatement updateName = updateConn.prepareStatement("UPDATE user SET nama=? WHERE email=?");
            updateName.setString(1, newName);
            updateName.setString(2, email);
            updateName.executeUpdate();
            updateName.close();

            session.setAttribute("user", newName);
            user = newName;
        } catch (Exception e) {
            out.println("<script>alert('Gagal update nama: " + e.getMessage() + "');</script>");
        } finally {
            if (updateConn != null) updateConn.close();
        }
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
    <title>Landing Page - 🏛️ MuseumPatung</title>
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <script src="js/bootstrap.bundle.min.js"></script>
    <style>
        :root {
            --maroon:#5b2c2c;
            --maroon-light:#7a3d3d;
            --gold:#d4af37;
            --bg:#f6f4ef;
            --card-border:#e8dfd1;
        }
        body{background-color:var(--bg);font-family:'Segoe UI',sans-serif;}
        .navbar{background-color:var(--maroon);}
        .navbar-brand,.nav-link{color:#fff !important;font-weight:600;letter-spacing:.5px;}
        .nav-link:hover{color:var(--gold) !important;}
        .product-card{border:1px solid var(--card-border);border-radius:12px;padding:16px;background-color:#fff;transition:.3s ease;height:100%;display:flex;flex-direction:column;justify-content:space-between;}
        .product-card:hover{transform:translateY(-5px);box-shadow:0 6px 20px rgba(0,0,0,.15);}
        .product-img{width:100%;height:220px;object-fit:cover;border-radius:8px;border:1px solid var(--card-border);}
        .product-title{font-size:18px;font-weight:600;margin-top:12px;color:var(--maroon);}
        .product-price{color:var(--maroon-light);font-weight:700;}
        .rating-info{font-size:14px;color:#555;}
        .btn-group-custom{display:flex;gap:8px;margin-top:12px;flex-direction:column;}
        .btn-primary{background-color:var(--maroon);border:none;}
        .btn-primary:hover{background-color:var(--maroon-light);}
        .btn-warning{background-color:var(--gold);border:none;color:#000;}
        .btn-warning:hover{filter:brightness(.9);color:#000;}
        .footer{background-color:var(--maroon);color:#fff;text-align:center;padding:20px;margin-top:60px;}
    </style>
    <script>
        let produkDipilih = {};
        function bukaPopupJumlah(idProduk, nama, harga){
            produkDipilih = {idProduk, nama, harga};
            document.getElementById("inputJumlah").value = 1;
            const modal = new bootstrap.Modal(document.getElementById('jumlahModal'));
            modal.show();
        }
        function submitJumlah(){
            const jumlah = document.getElementById("inputJumlah").value;
            if(jumlah < 1){
                alert("Jumlah minimal 1");
                return;
            }
            const form = document.getElementById("formTambahKeranjang");
            document.getElementById("inputIdProduk").value = produkDipilih.idProduk;
            document.getElementById("inputHarga").value = produkDipilih.harga;
            document.getElementById("inputJumlahHidden").value = jumlah;
            form.submit();
        }
        function bukaPopupCheckout(idProduk){
            document.getElementById("checkoutIdProduk").value = idProduk;
            document.getElementById("ongkirCheckout").value = 10000;
            const modal = new bootstrap.Modal(document.getElementById("checkoutPopup"));
            modal.show();
        }
    </script>
</head>
<body>

<nav class="navbar navbar-expand-lg shadow-sm">
    <div class="container">
        <a class="navbar-brand" href="landingpage.jsp">🏛️ MuseumPatung</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon text-light"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <% if(user != null){ %>
                    <% if("user".equals(user)){ %>
                        <li class="nav-item">
                            <a class="nav-link" href="dashboard.jsp"><i class="fas fa-user-cog"></i> Dashboard</a>
                        </li>
                    <% } %>
                    <li class="nav-item">
                        <a class="nav-link" href="keranjang.jsp"><i class="fas fa-shopping-cart"></i> Keranjang</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="riwayat.jsp"><i class="fas fa-receipt"></i> Riwayat Pemesanan</a>
                   </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#" data-bs-toggle="modal" data-bs-target="#ubahNamaModal">Halo, <%= user %></a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="logout.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a>
                    </li>
                <% } else { %>
                    <li class="nav-item">
                        <a class="nav-link" href="login.jsp"><i class="fas fa-sign-in-alt"></i> Login</a>
                    </li>
                <% } %>
            </ul>
        </div>
    </div>
</nav>

<div class="container my-5">
    <h2 class="mb-4 text-center fw-semibold" style="color:var(--maroon);">Koleksi Terbaik Museum</h2>
    <div class="row g-4">
        <%
            NumberFormat rupiah = NumberFormat.getCurrencyInstance(new Locale("id","ID"));
            while(rs.next()){
                int idProduk = rs.getInt("id");
                String nama  = rs.getString("nama");
                int harga    = rs.getInt("harga");
        %>
        <div class="col-md-4 col-sm-6">
            <div class="product-card">
                <div>
                    <img src="gambar/<%= rs.getString("gambar") %>" class="product-img" alt="<%= nama %>">
                    <div class="product-title"><%= nama %></div>
                    <p>Stok: <%= rs.getInt("stock") %></p>
                    <p class="product-price"><%= rupiah.format(harga) %></p>
                    <p class="rating-info">Rating: <%= rs.getFloat("rating") %> ⭐ | Terjual: <%= rs.getInt("terjual") %></p>
                </div>
                <div class="btn-group-custom">
                    <button onclick="bukaPopupJumlah(<%= idProduk %>, '<%= nama.replace("'", "\\'") %>', <%= harga %>)" class="btn btn-primary w-100">
                        <i class="fas fa-cart-plus"></i> Tambah ke Keranjang
                    </button>
                    <button onclick="bukaPopupCheckout(<%= idProduk %>)" class="btn btn-warning w-100">
                        <i class="fas fa-bolt"></i> Beli Sekarang
                    </button>
                </div>
            </div>
        </div>
        <% } %>
    </div>
</div>

<!-- Modal Beli Sekarang -->
<div class="modal fade" id="checkoutPopup" tabindex="-1">
  <div class="modal-dialog">
    <form method="post" action="ProsesCheckoutServlet" class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Checkout Produk</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <input type="hidden" name="from" value="direct">
        <input type="hidden" name="id_produk" id="checkoutIdProduk">
        <div class="mb-3">
            <label>Alamat Pengiriman:</label>
            <textarea name="alamat" class="form-control" required></textarea>
        </div>
        <div class="mb-3">
            <label>Metode Pembayaran:</label>
            <select name="metode" class="form-control" required>
                <option value="Transfer Bank">Transfer Bank</option>
                <option value="COD">COD</option>
                <option value="QRIS">QRIS</option>
            </select>
        </div>
        <div class="mb-3">
            <label>Kode Promo (Opsional):</label>
            <input type="text" name="promo" class="form-control">
        </div>
        <div class="mb-3">
            <label>Ongkir:</label>
            <input type="number" name="ongkir" id="ongkirCheckout" class="form-control" required>
        </div>
      </div>
      <div class="modal-footer">
        <button type="submit" class="btn btn-success">Proses Checkout</button>
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
      </div>
    </form>
  </div>
</div>

<!-- Modal Tambah Keranjang -->
<div class="modal fade" id="jumlahModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <form method="post" action="TambahKeranjangServlet" id="formTambahKeranjang">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Masukkan Jumlah</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="id_produk" id="inputIdProduk">
                    <input type="hidden" name="harga" id="inputHarga">
                    <input type="hidden" name="jumlah" id="inputJumlahHidden">
                    <input type="number" id="inputJumlah" class="form-control" value="1" min="1">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                    <button type="button" class="btn btn-primary" onclick="submitJumlah()">Tambahkan</button>
                </div>
            </div>
        </form>
    </div>
</div>

<!-- Modal Ubah Nama -->
<div class="modal fade" id="ubahNamaModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <form method="post">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Ubah Nama Anda</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="text" name="newName" class="form-control" value="<%= user %>" required>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-primary">Simpan</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                </div>
            </div>
        </form>
    </div>
</div>

<div class="footer">
    &copy; 2025 🏛️ MuseumPatung. All rights reserved.
</div>

</body>
</html>
<%
    } catch(Exception e){
        out.println("<p style='color:red;'>Gagal mengambil data: " + e.getMessage() + "</p>");
    } finally {
        if(rs != null) rs.close();
        if(ps != null) ps.close();
        if(conn != null) conn.close();
    }
%>
