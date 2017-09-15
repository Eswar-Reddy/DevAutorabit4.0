public with sharing class SPCommunityErrorUtility {
    
    /*Constants*/
    public static String errMessage = Label.Problem_with_the_System;
    public static String invalidParams = Label.Invalid_Parameters;
    public static String unauthorizedUser = 'unauthorized user';
    /*Variables*/


    /*Constructors*/
    public SPCommunityErrorUtility() {  }


    //Get JSON Exception
    public static String generateExceptionJSON(Exception e) {
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('type', e.getTypeName());
        gen.writeStringField('message', errMessage);//will display generic error to the user
        gen.writeStringField('stack', e.getStackTraceString());
        gen.writeStringField('where', e.getLineNumber() == null ? '' : String.valueOf(e.getLineNumber()));
        gen.writeBooleanField('status', false);
        gen.writeEndObject();

        return gen.getAsString();
    }

    public static String generateDMLExceptionJSON(DmlException e) {
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('type', String.valueOf(e.getDmlType(0)));
        gen.writeStringField('message', e.getDmlMessage(0));
        gen.writeStringField('stack', e.getStackTraceString());
        gen.writeStringField('where', e.getLineNumber() == null ? '' : String.valueOf(e.getLineNumber()));
        gen.writeBooleanField('status', false);
        gen.writeEndObject();

        return gen.getAsString();
    }
}