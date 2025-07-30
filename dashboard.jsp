<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page session="true" %>
<%
    String user = (String) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8" />
    <title>Dashboard - 🏛️ Museum</title>
    <link rel="stylesheet" href="css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <style>
        /* Palet warna museum */
        :root{
            --maroon:#5b2c2c;
            --maroon-light:#7a3d3d;
            --gold:#d4af37;
            --ivory:#f6f4ef;
        }

        body{
            margin:0;
            font-family:'Segoe UI',sans-serif;
            background-color:var(--ivory);
        }

        /* Sidebar */
        .sidebar{
            width:200px;
            background-color:var(--maroon);
            color:#fff;
            min-height:100vh;
            padding:20px;
            position:fixed;
            top:0;
            left:0;
        }
        .sidebar h2{
            font-size:18px;
            margin-bottom:30px;
            color:var(--gold);
        }
        .sidebar ul{
            list-style-type:none;
            padding:0;
        }
        .sidebar ul li{
            margin:15px 0;
        }
        .sidebar ul li a{
            color:#fff;
            text-decoration:none;
            display:flex;
            align-items:center;
            gap:8px;
        }
        .sidebar ul li a:hover{
            color:var(--gold);
        }
        .sidebar .logout-link{
            margin-top:30px;
            color:var(--gold);
            text-decoration:none;
            display:flex;
            align-items:center;
            gap:8px;
            font-weight:bold;
        }
        .sidebar .logout-link:hover{
            opacity:0.85;
        }

        /* Konten utama */
        .main-content{
            margin-left:200px;
            padding:40px;
        }
        .main-content h1{
            font-size:24px;
            margin-bottom:20px;
            color:var(--maroon);
        }
        .section-card{
            background-color:#ffffff;
            padding:20px;
            border-radius:10px;
            box-shadow:0 2px 10px rgba(0,0,0,0.1);
            margin-bottom:30px;
        }
        .section-card h3{
            margin-top:0;
            margin-bottom:10px;
            font-size:20px;
            color:var(--maroon);
        }

        /* Kartu “Menu Master” */
        .menu-master-card{
            background-color:#f2e8df;        /* krem lembut */
            border-left:5px solid var(--gold);
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <h2>MUSEUM</h2>
        <ul>
            <li><a href="landingpage.jsp"><i class="fa fa-home"></i> Home</a></li>
            <li><a href="data-register.jsp"><i class="fa fa-users"></i> Data Register</a></li>
            <li><a href="data-barang.jsp"><i class="fa fa-plus-circle"></i> Data Barang</a></li>
            <li><a href="data-pemesan.jsp"><i class="fa fa-clock"></i> Riwayat Pesanan</a></li>
        </ul>
        <a href="logout.jsp" class="logout-link"><i class="fa fa-sign-out-alt"></i> Logout</a>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <h1>Selamat Datang, <%= user %></h1>

        <div class="section-card menu-master-card">
            <h3>Menu Master</h3>
            <p>Gunakan menu di sebelah kiri untuk mengakses data register, data pemesanan, data produk, tambah produk, dan melihat riwayat pesanan.</p>
        </div>
    </div>
</body>
</html>
