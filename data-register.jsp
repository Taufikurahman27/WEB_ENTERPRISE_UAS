<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Data Register</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            display: flex;
            margin: 0;
            font-family: Arial, sans-serif;
        }
        .sidebar {
            width: 250px;
            height: 100vh;
            background-color: #5b3e2f; /* Warna coklat kayu museum */
            color: #fff8e1;
            padding: 20px;
        }
        .sidebar h4 {
            color: #fdd835; /* Emas */
            margin-bottom: 30px;
        }
        .sidebar a {
            color: #fff8e1;
            display: block;
            padding: 10px 0;
            text-decoration: none;
        }
        .sidebar a:hover {
            color: #fdd835; /* Hover emas */
        }
        .content {
            flex-grow: 1;
            padding: 40px;
            background-color: #f7f4f1;
            min-height: 100vh;
        }
        .content h2 {
            color: #6c4f3d;
            font-family: 'Georgia', serif;
        }
        .table {
            background-color: #fff8e1;
            border-radius: 8px;
        }
        .table th {
            background-color: #c6a46e;
            color: #fff;
        }
        .table-striped tbody tr:nth-of-type(odd) {
            background-color: #f5f3e5;
        }
        .btn-info {
            background-color: #6c4f3d;
            border-color: #6c4f3d;
        }
        .btn-info:hover {
            background-color: #5b3e2f;
            border-color: #5b3e2f;
        }
        .btn-warning {
            background-color: #f8a659;
            border-color: #f8a659;
        }
        .btn-warning:hover {
            background-color: #d98c47;
            border-color: #d98c47;
        }
        .btn-danger {
            background-color: #e53935;
            border-color: #e53935;
        }
        .btn-danger:hover {
            background-color: #c62828;
            border-color: #c62828;
        }
    </style>
</head>
<body>

<div class="sidebar">
    <h4>MUSEUM</h4>
    <a href="dashboard.jsp">🏠 Home</a>
    <a href="data-register.jsp">👥 Data Register</a>
    <a href="data-barang.jsp">➕ Data Barang</a>
    <a href="data-pemesan.jsp">🕒 Riwayat Pesanan</a>
    <a href="logout.jsp" style="color: red;">⎋ Logout</a>
</div>

<div class="content">
    <h2>Data Register</h2>
    <table class="table table-striped mt-4">
        <thead>
            <tr>
                <th>No</th>
                <th>Nama</th>
                <th>Email</th>
                <th>Aksi</th>
            </tr>
        </thead>
        <tbody>
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db_nugas", "root", "");
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT * FROM user");
                int no = 1;
                while (rs.next()) {
                    int id = rs.getInt("id");
                    String nama = rs.getString("nama");
                    String email = rs.getString("email");
        %>
            <tr>
                <td><%= no++ %></td>
                <td><%= nama %></td>
                <td><%= email %></td>
                <td>
                    <button class="btn btn-warning btn-sm" onclick="showEditModal('<%= id %>', '<%= nama %>', '<%= email %>')">Edit</button>
                    <a href="delete-user.jsp?id=<%= id %>" class="btn btn-danger btn-sm" onclick="return confirm('Apakah Anda yakin ingin menghapus data ini?')">Hapus</a>
                </td>
            </tr>
        <%
                }
                rs.close();
                stmt.close();
                conn.close();
            } catch (Exception e) {
                out.println("<tr><td colspan='4'>Error: " + e.getMessage() + "</td></tr>");
            }
        %>
        </tbody>
    </table>
</div>

<!-- Modal Edit -->
<div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="update-user.jsp" method="post">
                <div class="modal-header">
                    <h5 class="modal-title" id="editModalLabel">Edit User</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="id" id="editId">
                    <div class="mb-3">
                        <label>Nama</label>
                        <input type="text" name="nama" id="editNama" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label>Email</label>
                        <input type="email" name="email" id="editEmail" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label>Password</label>
                        <input type="password" name="password" id="editPassword" class="form-control" placeholder="Masukkan password baru (opsional)">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-primary">Simpan</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="js/bootstrap.bundle.min.js"></script>
<script>
    function showEditModal(id, nama, email) {
        document.getElementById('editId').value = id;
        document.getElementById('editNama').value = nama;
        document.getElementById('editEmail').value = email;
        var modal = new bootstrap.Modal(document.getElementById('editModal'));
        modal.show();
    }
</script>

</body>
</html>
