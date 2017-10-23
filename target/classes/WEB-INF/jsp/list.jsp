<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@include file="common/tag.jsp"%>

<!DOCTYPE html>
<html lang="zh-CN">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- 上述3个meta标签*必须*放在最前面，任何其他内容都*必须*跟随其后！ -->
    <title>秒杀商品列表</title>
    <%@include file="common/head.jsp" %>
  </head>
  
	<body>
		<div class="container">
		    <div class="panel panel-default">
		        <div class="panel-heading text-center">
		            <h2>列表</h2>
		        </div>
		        <div class="panel-body">
		            <table class="table table-hover">
		                <thead>
		                <tr>
		                    <th>名称</th>
		                    <th>库存</th>
		                    <th>开始时间</th>
		                    <th>结束时间</th>
		                    <th>创建时间</th>
		                    <th>详情页</th>
		                </tr>
		                </thead>
		                <tbody>
		                <c:forEach items="${list}" var="sk">
		                    <tr>
		                        <td>${sk.name}</td>
		                        <td>${sk.number}</td>
		                        <td>
		                            <fmt:formatDate value="${sk.startTime}" pattern="yyyy-MM-dd HH:mm:ss" />
		                        </td>
		                        <td>
		                            <fmt:formatDate value="${sk.endTime}" pattern="yyyy-MM-dd HH:mm:ss" />
		                        </td>
		                        <td>
		                            <fmt:formatDate value="${sk.createTime}" pattern="yyyy-MM-dd HH:mm:ss" />
		                        </td>
		                        <td><a class="btn btn-info" href="/Seckill/${sk.seckillId}/detail">详情</a></td>
		                    </tr>
		                </c:forEach>
		                </tbody>
		            </table>
		
		        </div>
		    </div>
		</div>

    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script type="text/javascript" src="http://ajax.microsoft.com/ajax/jquery/jquery-3.2.1.min.js"></script>
    
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="https://cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
  </body>
</html>