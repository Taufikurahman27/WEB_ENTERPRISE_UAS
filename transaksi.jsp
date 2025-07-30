<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page session="true" %>
<%
    String user = (String) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String produk = request.getParameter("produk");
    String hargaStr = request.getParameter("harga");
    String gambar = request.getParameter("gambar");

    int harga = 0;
    try {
        harga = Integer.parseInt(hargaStr.replaceAll("[^\\d]", ""));
    } catch (Exception e) {
        harga = 0;
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Transaksi - Museum Patung</title>
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(to bottom right, #f3e9dc, #fffaf0);
            font-family: 'Segoe UI', sans-serif;
            color: #4e342e;
        }
        .container {
            background-color: #fffaf0;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 6px 18px rgba(0,0,0,0.1);
            margin-top: 40px;
        }
        .produk-img {
            border-radius: 12px;
            border: 2px solid #d7ccc8;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .badge-harga {
            font-size: 16px;
            background-color: #d7ccc8;
            color: #3e2723;
            padding: 5px 12px;
            border-radius: 20px;
        }
    </style>
</head>
<body>

<div class="container mt-3">
    <a href="dashboard.jsp" class="btn btn-secondary mb-3">
        <i class="fas fa-arrow-left"></i> Kembali ke Dashboard
    </a>

    <h2>Transaksi Pembelian</h2>

    <div class="row">
        <div class="col-md-5 text-center">
            <img src="image/<%= gambar %>" class="img-fluid produk-img" alt="<%= produk %>">
            <h4 class="mt-3"><%= produk %></h4>
            <span class="badge-harga">Harga Satuan: Rp <%= String.format("%,d", harga).replace(',', '.') %></span>
        </div>

        <div class="col-md-7">
            <form method="POST" action="proses-transaksi.jsp">
                <input type="hidden" name="produk" value="<%= produk %>">
                <input type="hidden" name="harga" value="<%= harga %>">

                <div class="mb-3">
                    <label for="quantity" class="form-label">Jumlah:</label>
                    <input type="number" class="form-control" id="quantity" name="quantity" min="1" value="1" onchange="hitungTotal()">
                </div>

                <div class="mb-3">
                    <label for="alamat" class="form-label">Alamat Pengiriman:</label>
                    <textarea class="form-control" name="alamat" id="alamat" rows="3" required></textarea>
                </div>

                <div class="mb-3">
                    <label for="metode" class="form-label">Metode Pembayaran:</label>
                    <select class="form-select" name="metode" id="metode" required>
                        <option value="Transfer Bank">Transfer Bank</option>
                        <option value="COD">Bayar di Tempat (COD)</option>
                        <option value="E-Wallet">E-Wallet</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label for="promo" class="form-label">Kode Promo (opsional):</label>
                    <input type="text" class="form-control" name="promo" id="promo">
                </div>

                <div class="mb-3">
                    <label for="ongkir" class="form-label">Ongkos Kirim:</label>
                    <select class="form-select" name="ongkir" id="ongkir" onchange="hitungTotal()">
                        <option value="10000">Reguler - Rp 10.000</option>
                        <option value="20000">Express - Rp 20.000</option>
                        <option value="0">Ambil di Tempat - Gratis</option>
                    </select>
                </div>

                <div class="mb-4">
                    <label class="form-label">Total Harga:</label>
                    <input type="text" class="form-control" id="totalHarga" name="totalHarga" readonly>
                </div>

                <button type="submit" class="btn btn-primary w-100">
                    <i class="fas fa-shopping-cart"></i> Pesan Sekarang
                </button>
            </form>
        </div>
    </div>
</div>

<script>
    let hargaSatuan = <%= harga %>;

    function hitungTotal() {
        let qty = parseInt(document.getElementById("quantity").value) || 1;
        let ongkir = parseInt(document.getElementById("ongkir").value) || 0;
        let total = (qty * hargaSatuan) + ongkir;
        document.getElementById("totalHarga").value = "Rp " + total.toLocaleString("id-ID");
    }

    window.onload = hitungTotal;
</script>

</body>
</html>
