-- In dit bestand zet je je package specificatie. Hier komen alle specificaties van je publieke functies.
CREATE
    OR REPLACE PACKAGE PKG_MOVIES IS
    PROCEDURE PRINTREPORT_2_LEVELS_M6(P_AMOUNT_MOVIES IN NUMBER, P_AMOUNT_PERFORMANCES IN NUMBER, P_AMOUNT_TICKETS IN NUMBER);
    PROCEDURE EMPTY_TABLES;
    PROCEDURE BEWIJS_MILESTONE_5;
    PROCEDURE COMPARISON_SINGLE_BULK_M7(P_THEATHERS_AMOUNT IN NUMBER, P_HALLS_AMOUNT IN NUMBER,
                                        P_PERFORMANCES_AMOUNT IN NUMBER);
    PROCEDURE MANUAL_INPUT_M4;
END;