package com.gc.spring;

import java.lang.reflect.Field;
import java.util.Iterator;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.HibernateException;
import org.hibernate.cfg.Configuration;
import org.hibernate.mapping.Formula;
import org.hibernate.mapping.Property;
import org.hibernate.mapping.RootClass;
import org.hibernate.mapping.SimpleValue;
import org.hibernate.mapping.Value;
import org.springframework.orm.hibernate3.LocalSessionFactoryBean;

public class GCSessionFactoryBean extends LocalSessionFactoryBean {

	private static Log _log = LogFactory.getLog(GCSessionFactoryBean.class);

	private final static Pattern fp = Pattern.compile("AES_DECRYPT\\((\\w+), '\\w+'\\)");

	protected Configuration newConfiguration() throws HibernateException {
		Configuration config = getConfiguration();
		if(config == null) config = super.newConfiguration();
		return config;
	}

	protected void postProcessConfiguration(Configuration config) throws HibernateException {
		try {
			RootClass rc;
			Iterator props;
			Property prop;
			Value v;
			SimpleValue sv;
			Iterator columns;
			Formula f;
			Object column;
			for(Iterator it = config.getClassMappings(); it.hasNext(); ){
				rc = (RootClass)it.next();
				props = rc.getPropertyIterator();
				while(props.hasNext()) {
					prop = (Property) props.next();
					v = prop.getValue();
					if(v.isSimpleValue()) {
						sv = (SimpleValue) v;
						columns = sv.getColumnIterator();
						while(columns.hasNext()) {
							column = columns.next();
							if(column instanceof Formula) {
								f = (Formula) column;
								changeFormula(f);
							}
						}
					}
				}
			}
			changePassword();
		} catch(Exception e) {
			_log.error(e, e);
		}
	}

	private void changeFormula(Formula f) {
		String formula = f.getFormula();
		Matcher fm = fp.matcher(formula);
		String column;
		if(fm.matches()) {
			column = fm.group(1);
			formula = "AES_DECRYPT(" + column + ", 'JC2aadv11')";
			f.setFormula(formula);
		}
	}

	private void changePassword() throws Exception {
		Class constClazz = Class.forName("com.agloco.Constants");
		Field field = getField(constClazz, "AGLOCO_AESKEY", String.class);
		field.setAccessible(true);
		StringBuffer sb = (StringBuffer) field.get(constClazz);
		sb.delete(0, sb.length());
		sb.append("JC2aadv11");
	}

	/**
	 * @param clazz
	 * @param name
	 * @param type
	 * @return
	 * @throws NoSuchFieldException
	 * @throws SecurityException
	 */
	private static Field getField(Class clazz, String name, Class type)
		throws NoSuchFieldException, SecurityException
	{
		if(null == clazz || null == name) throw new NullPointerException();
		Field field = null;
		try {
			field = clazz.getField(name);
		} catch(Exception e) {
			field = null;
		}
		Field[] fields = null;
		Class superClazz = null;
		while(field == null && clazz != superClazz) {
			fields = clazz.getDeclaredFields();
			for(int i = 0; i < fields.length; i++) {
				if(fields[i].getName().equals(name)
					&& (type == null
						|| (type != null
							&& type.isAssignableFrom(fields[i].getType())
				))) {
					field = fields[i];
					break;
				}
			}
			clazz = clazz.getSuperclass();
			superClazz = clazz.getSuperclass();
		}
		return field;
	}

}
