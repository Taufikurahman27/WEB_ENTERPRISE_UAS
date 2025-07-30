<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Registrasi | Museum Digital</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;700&display=swap" rel="stylesheet">
    <style>
        /* Palet warna museum */
        :root{
            --maroon: #5b2c2c;
            --maroon-light: #7a3d3d;
            --gold: #d4af37;
            --ivory: #f6f4ef;
        }

        body{
            background: transparent;
            font-family: 'Nunito', sans-serif;
            color: #333;
            min-height: 100vh;
        }

        /* Navbar */
        .navbar-custom{
            background-color: rgba(255, 255, 255, 0.9);
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        .navbar-brand{
            font-weight: bold;
            color: var(--maroon) !important;
        }
        .nav-link{
            color: var(--maroon) !important;
            font-weight: 600;
        }

        /* Kartu formulir */
        .card-custom{
            background-color: #ffffff;
            border-radius: 18px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
            max-width: 950px;
            margin: 60px auto;
            overflow: hidden;
        }
        .form-section{
            padding: 40px;
        }
        .form-label{
            font-weight: 600;
        }
        .form-control{
            border-radius: 10px;
        }

        /* Tombol submit */
        .btn-submit{
            background: linear-gradient(45deg, var(--maroon-light), var(--gold));
            color: #fff;
            border: none;
            border-radius: 10px;
            padding: 10px 26px;
            font-weight: 600;
            transition: 0.3s ease;
        }
        .btn-submit:hover{
            opacity: 0.9;
        }

        /* Sisi gambar */
        .image-section{
            background: var(--ivory);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 30px;
        }
        .image-section img{
            max-width: 100%;
            border-radius: 10px;
        }

        /* Warna heading “Daftar Akun Museum” */
        .text-primary{
            color: var(--maroon) !important;
        }

        /* Footer */
        footer{
            background-color: var(--maroon);
            color: white;
            font-size: 14px;
        }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-light navbar-custom">
    <div class="container">
        <a class="navbar-brand" href="#">Museum Digital</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                data-bs-target="#navbarNav" aria-controls="navbarNav"
                aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item"><a class="nav-link" href="index.html">Beranda</a></li>
                <li class="nav-item"><a class="nav-link active" href="#">Registrasi</a></li>
                <li class="nav-item"><a class="nav-link" href="login.jsp">Login</a></li>
            </ul>
        </div>
    </div>
</nav>

<!-- Form Registrasi -->
<div class="container">
    <div class="card card-custom">
        <div class="row g-0">
            <!-- Form -->
            <div class="col-md-6 form-section">
                <h3 class="text-center text-primary mb-4">Daftar Akun Museum</h3>
                <form action="simpan.jsp" method="post">
                    <div class="mb-3">
                        <label class="form-label">Nama Lengkap</label>
                        <input type="text" name="nama" class="form-control" required placeholder="Contoh: John Doe" />
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" name="email" class="form-control" required placeholder="nama@email.com" />
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Password</label>
                        <input type="password" name="password" class="form-control" required placeholder="••••••" />
                    </div>
                    <div class="text-center mt-4">
                        <input type="submit" value="Daftar Sekarang" class="btn btn-submit" />
                    </div>
                </form>
            </div>

            <!-- Gambar -->
            <div class="col-md-6 image-section">
                <img src="image/museumm.jpeg" alt="Museum Sign Up">
            </div>
        </div>
    </div>
</div>

<!-- Footer -->
<footer class="text-center py-3 mt-5">
    <p class="mb-0">©️ 2025 Museum Digital | Semua Hak Dilindungi</p>
</footer>

<script src="js/bootstrap.bundle.min.js"></script>
</body>
</html>
