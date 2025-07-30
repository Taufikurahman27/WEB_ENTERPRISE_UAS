<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Login | 🏛️ MuseumPatung</title>

    <!-- Bootstrap & font -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">

    <!-- Tema museum -->
    <style>
        :root {
            --maroon: #5b2c2c;
            --maroon-light: #7a3d3d;
            --gold: #d4af37;
        }

        body {
            background: url('image/msm.jpg') no-repeat center center fixed;
            background-size: cover;
            font-family: 'Poppins', sans-serif;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
        }

        .login-card {
            background: rgba(91, 44, 44, 0.80);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 20px;
            padding: 40px 30px;
            width: 100%;
            max-width: 420px;
            color: #fff;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.6);
        }

        .login-card h2 {
            font-weight: 600;
            margin-bottom: 10px;
        }

        .login-card .icon {
            font-size: 48px;
            margin-bottom: 10px;
            color: var(--gold);
        }

        .form-control {
            border-radius: 12px;
        }

        .btn-login {
            background-color: var(--gold);
            border: none;
            padding: 12px;
            font-weight: 600;
            width: 100%;
            border-radius: 30px;
            color: #000;
            transition: background-color 0.3s ease;
        }

        .btn-login:hover {
            background-color: #c19c2e;
            color: #000;
        }

        .google-btn {
            background: #fff;
            color: #444;
            border: none;
            border-radius: 30px;
            padding: 10px;
            font-weight: 500;
            display: flex;
            align-items: center;
            justify-content: center;
            width: 100%;
            text-decoration: none;
        }

        .google-btn img {
            height: 20px;
            margin-right: 10px;
        }

        .alert {
            border-radius: 10px;
            font-size: 14px;
        }
    </style>
</head>
<body>

<%
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    boolean loginAttempt = (email != null && password != null);
    boolean success = false;
    String nama = "";

    if (loginAttempt) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db_nugas", "root", "");
            PreparedStatement stmt = conn.prepareStatement("SELECT * FROM user WHERE email=? AND password=?");
            stmt.setString(1, email);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                success = true;
                nama = rs.getString("nama");
            }

            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            out.println("Database error: " + e.getMessage());
        }

        if (success) {
            session.setAttribute("user", nama);
            if ("pikkk".equalsIgnoreCase(nama)) {
                response.sendRedirect("dashboard.jsp");
            } else {
                response.sendRedirect("landingpage.jsp");
            }
            return;
        }
    }
%>

<div class="login-card">
    <div class="text-center">
        <div class="icon">🏛️</div>
        <h2>MuseumPatung</h2>
        <p class="mb-4">Silakan masuk untuk melanjutkan</p>
    </div>

    <% if (loginAttempt && !success) { %>
        <div class="alert alert-danger text-center">Email atau password salah!</div>
    <% } %>

    <form method="post">
        <div class="mb-3">
            <label>Email</label>
            <input type="email" name="email" class="form-control" required>
        </div>
        <div class="mb-3">
            <label>Password</label>
            <input type="password" name="password" class="form-control" required>
        </div>
        <button type="submit" class="btn btn-login">Masuk</button>
    </form>

    <hr class="my-4">

    <!-- Tombol Login Google -->
    <div class="text-center">
        <a href="https://accounts.google.com/o/oauth2/v2/auth?scope=email%20profile&access_type=online&include_granted_scopes=true&response_type=code&redirect_uri=http://localhost:8080/WebEnterprise/oauth2callback.jsp&client_id=306006062454-q0ofsd5co2npclc8ratr40v0tpkn1rva.apps.googleusercontent.com"
           class="google-btn">
            <img src="https://developers.google.com/identity/images/g-logo.png" alt="Google Logo">
            Login dengan Google
        </a>
    </div>
</div>

<script src="js/bootstrap.bundle.min.js"></script>
</body>
</html>
