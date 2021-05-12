package com.bjpowernode.crm.handler;

import com.bjpowernode.crm.exception.LoginException;
import com.bjpowernode.crm.exception.ResetException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;


@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(value = LoginException.class)
    @ResponseBody
    public Map doLoginException(Exception exception){
        Map map = new HashMap<>();
        map.put("success",false);
        map.put("msg",exception.getMessage());
        return map;
    }

    @ExceptionHandler(value = ResetException.class)
    @ResponseBody
    public Map doResetException(Exception exception){
        Map map = new HashMap<>();
        map.put("success",false);
        map.put("msg",exception.getMessage());
        return map;
    }


    @ExceptionHandler
    public void doOtherException(Exception exception){
        exception.printStackTrace();
    }

}
