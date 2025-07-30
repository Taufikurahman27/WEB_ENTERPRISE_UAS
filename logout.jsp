<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    session.invalidate(); // Menghapus semua atribut session
    response.sendRedirect("index.html"); // Redirect ke index.html
%>
