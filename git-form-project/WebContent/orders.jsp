<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
</head>
<body>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.SQLException" %>

<%
	String orderDate = request.getParameter("orderDate");
	System.out.println(orderDate);
	
	// 1. select amount from orders where order_date=?
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
		
	try {	
		Class.forName("com.mysql.jdbc.Driver");
		
		String jdbcDriver = "jdbc:mysql://localhost:3306/jjdev?" +
				"useUnicode=true&characterEncoding=euckr";
		String dbUser = "root";
		String dbPass = "java0000";
		conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
		
		String sql = "SELECT amount FROM orders WHERE order_date=?";
		
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, orderDate);
		System.out.println(pstmt + "<-- pstmt   orders.jsp");
		
		rs = pstmt.executeQuery();
		System.out.println(rs + "<-- rs   orders.jsp");
		
		int amount = 0;
		if(rs.next()) {
			amount = rs.getInt("amount");
		} else {
			out.println("공연이 없습니다.");
		}
		// 2. 1의 결과가 0이면 매진
		// 3. 1의 결과가 0보다 크면
		// 3-1. update orders set amount=amount-1 where order_date=?
		
		if(amount == 0) {
			out.println("매진!");
		} else {
			sql = "update orders set amount=amount-1 where order_date=?";
			PreparedStatement stmt2 = conn.prepareStatement(sql);
			stmt2.setString(1, orderDate);
			stmt2.executeUpdate();
			out.println("주문 성공");
		}
		
	} catch(SQLException ex) {
		ex.printStackTrace();
	} finally {
		if (rs != null) try { rs.close(); } catch(SQLException ex) {}
		if (pstmt != null) try { pstmt.close(); } catch(SQLException ex) {}
		if (conn != null) try { conn.close(); } catch(SQLException ex) {}
	}
%>

</body>
</html>