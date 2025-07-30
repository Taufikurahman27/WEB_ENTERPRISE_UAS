<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
    String user = (String) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    request.setCharacterEncoding("UTF-8");

    String produk = request.getParameter("produk");
    String hargaStr = request.getParameter("harga");
    String quantityStr = request.getParameter("quantity");
    String alamat = request.getParameter("alamat");
    String metode = request.getParameter("metode");
    String promo = request.getParameter("promo");
    String ongkirStr = request.getParameter("ongkir");

    try {
        int harga = Integer.parseInt(hargaStr);
        int quantity = Integer.parseInt(quantityStr);
        int ongkir = Integer.parseInt(ongkirStr);
        int total_harga = (harga * quantity) + ongkir;

        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db_nugas", "root", "");

        String sql = "INSERT INTO transaksi (user, produk, harga, quantity, total_harga, alamat, metode, promo, ongkir) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, user);
        ps.setString(2, produk);
        ps.setInt(3, harga);
        ps.setInt(4, quantity);
        ps.setInt(5, total_harga);
        ps.setString(6, alamat);
        ps.setString(7, metode);
        ps.setString(8, promo != null ? promo : "");
        ps.setInt(9, ongkir);

        ps.executeUpdate();
        ps.close();
        conn.close();

        out.println("<script>alert('Transaksi berhasil disimpan!'); window.location='dashboard.jsp';</script>");
    } catch (Exception e) {
        out.println("<script>alert('Gagal menyimpan transaksi: " + e.getMessage() + "'); history.back();</script>");
    }
%>
