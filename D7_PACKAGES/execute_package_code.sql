-- In dit bestand voor je alle code uit die je package aanroept.
-- een oproep van de package zit tussen een BEGIN en een END blok

BEGIN
    PKG_MOVIES.EMPTY_TABLES();
    PKG_MOVIES.COMPARISON_SINGLE_BULK_M7(20,40,50);
    PKG_MOVIES.COMPARISON_SINGLE_BULK_M7(20,40,500);
END;

BEGIN
    PKG_MOVIES.PRINTREPORT_2_LEVELS_M6(7,1,1);
    PKG_MOVIES.PRINTREPORT_2_LEVELS_M6(3,-2,3);
end;

BEGIN
    PKG_MOVIES.EMPTY_TABLES();
    PKG_MOVIES.MANUAL_INPUT_M4();
    PKG_MOVIES.BEWIJS_MILESTONE_5();
END;

BEGIN
    PKG_MOVIES.EMPTY_TABLES();
    PKG_MOVIES.MANUAL_INPUT_M4();
END;

