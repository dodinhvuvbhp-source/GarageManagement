package com.garage.tag;

import jakarta.servlet.jsp.JspException;
import jakarta.servlet.jsp.JspWriter;
import jakarta.servlet.jsp.tagext.SimpleTagSupport;
import java.io.IOException;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.util.Locale;

public class CurrencyFormatTag extends SimpleTagSupport {
    private Object value;

    public void setValue(Object value) {
        this.value = value;
    }

    @Override
    public void doTag() throws JspException, IOException {
        JspWriter out = getJspContext().getOut();
        if (value == null) {
            out.print("0 đ");
            return;
        }

        try {
            BigDecimal amount;
            if (value instanceof BigDecimal) {
                amount = (BigDecimal) value;
            } else if (value instanceof Number) {
                amount = new BigDecimal(value.toString());
            } else {
                amount = new BigDecimal(value.toString().trim());
            }

            DecimalFormatSymbols symbols = new DecimalFormatSymbols(new Locale("vi", "VN"));
            symbols.setGroupingSeparator('.');
            DecimalFormat formatter = new DecimalFormat("#,##0", symbols);
            out.print(formatter.format(amount) + " đ");
        } catch (Exception e) {
            out.print(value.toString() + " đ");
        }
    }
}
