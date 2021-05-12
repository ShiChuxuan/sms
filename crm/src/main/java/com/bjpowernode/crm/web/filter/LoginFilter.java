package com.bjpowernode.crm.web.filter;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class LoginFilter implements Filter {
    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;

        String path = request.getServletPath();

        if("/login.jsp".equals(path)||"/settings/user/login.do".equals(path)){
            filterChain.doFilter(servletRequest,servletResponse);
        }else{
            System.out.println("===拦截===");
            if(request.getSession(false)==null){
                System.out.println("===恶意访问===");
                response.sendRedirect(request.getContextPath()+"/login.jsp");
                return;
            }
            System.out.println("===合法访问===");
            filterChain.doFilter(servletRequest,servletResponse);
        }


    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    @Override
    public void destroy() {

    }
}
