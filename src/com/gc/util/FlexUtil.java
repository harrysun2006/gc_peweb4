package com.gc.util;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.lang.reflect.Method;
import java.util.List;

import com.gc.exception.CommonRuntimeException;

import flex.messaging.MessageException;
import flex.messaging.io.SerializationContext;
import flex.messaging.io.amf.Amf3Input;
import flex.messaging.io.amf.Amf3Output;
import flex.messaging.security.SecurityException;
import flex.messaging.util.MethodMatcher;
import flex.messaging.util.MethodMatcher.Match;

public class FlexUtil {

	private FlexUtil() {}

	public static Object readObject(byte[] b) throws IOException, ClassNotFoundException {
	 	SerializationContext context = SerializationContext.getSerializationContext();
	 	Amf3Input amf3Input = new Amf3Input(context);
	 	amf3Input.setInputStream(new ByteArrayInputStream(b));
		return amf3Input.readObject();
	}

	public static byte[] writeObject(Object obj) throws IOException {
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		SerializationContext context = SerializationContext.getSerializationContext();
		Amf3Output amf3Output = new Amf3Output(context);
		amf3Output.setOutputStream(baos);
		amf3Output.writeObject(obj);
		return baos.toByteArray();
	}

	public static Method findMethod(Class clazz, String name, List params) {
		MethodMatcher mm = new MethodMatcher();
		return mm.getMethod(clazz, name, params);
	}

	public static void convertParams(List params, Method method) {
		MethodMatcher.convertParams(params, method.getParameterTypes(), new Match(method.getName()));
	}

	public static MessageException translate(Throwable t) {
		if (t instanceof CommonRuntimeException) {
			SecurityException se = new SecurityException();
			se.setCode(SecurityException.CLIENT_AUTHENTICATION_CODE);
			se.setMessage(t.getLocalizedMessage());
			se.setRootCause(t);
			se.setDetails(t.getClass().getName());
			return se;
		} else {
			MessageException me = new MessageException(t.getMessage());
			me.setRootCause(CommonUtil.getRootCause(t));
			return me;
		}
	}
}
