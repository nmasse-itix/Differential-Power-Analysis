
package dpa;

import java.math.*;
import java.io.*;

/** Version multi-bits de la DPA sur RSA.
 * Note: C'est une version de test ! 
 *
 * Mode d'emploi:
 * Il faut placer les traces de courant dans le répertoire "traces".
 *
 * Résultats: 
 * Les résultats sont FAUX. 
 *
 * A faire:
 * Voir pourquoi les résultats sont faux. La documentation (payante)
 * est disponible à http://www.springerlink.com/content/4ugk06uu0y8hf5ue/
 * 
 * Les traces de courant sont disponibles sur 
 * https://projects.itix.fr/studies/DPA/trac/wiki/TracesDeCourant
 *
 * @author nicolas.masse
 */
public class RsaTest2 {
    
    public static void main(String[] args) {
        
        
        int ntraces = 5000;
        
        BigInteger[] msg = new BigInteger[ntraces];
        for (int i = 0; i < ntraces; i++) {
            try {
                BufferedReader in = new BufferedReader(new FileReader("traces/msg_" + goodform(i+1) + ".dat"));
                msg[i] = new BigInteger(in.readLine());
            } catch (IOException ex) {
                ex.printStackTrace();
                System.exit(1);
            }
            
            if ((i+1) % 1000 == 0) { 
                System.out.println("Loaded " + (i+1) + " clear messages..."); 
            }
        }
        
        int [][] traces = new int[ntraces][3536];
        for (int i = 0; i < ntraces; i++) {
            try {
                BufferedReader in = new BufferedReader(new FileReader("traces/SM_32_" + goodform(i+1) + ".dat"));
                for (int j = 0; j < 3536; j++) {
                    traces[i][j] = Integer.parseInt(in.readLine());
                }
                
            } catch (IOException ex) {
                ex.printStackTrace();
                System.exit(1);
            }
            
            if ((i+1) % 1000 == 0) { 
                System.out.println("Loaded " + (i+1) + " traces..."); 
            }
        }
        
        // The public key
        BigInteger n = new BigInteger("115753540889062431344172474906327728114200335452658415236258067817852290090837");
        BigInteger e = new BigInteger("3");
        
        System.out.println("n = " + n);
        System.out.println("Checking n...");
        if (n.isProbablePrime(1024)) {
            System.out.println("  n is probably a prime number.");
        } else {
            System.out.println("  n is definitely NOT a prime number.");
        }
        
        System.out.println("e = " + e);
        System.out.println("Checking e...");
        if (e.isProbablePrime(1024)) {
            System.out.println("  e is probably a prime number.");
        } else {
            System.out.println("  e is definitely NOT a prime number.");
        }
        
        System.out.println("Breaking the key...");
        BigInteger key = dpa(256, msg, traces, n);
        //BigInteger key = new BigInteger("77169027259374954229448316604218485408995432318477845515909257059866234615730");
        
        System.out.println("  d = " + key);
        System.out.println("Checking the private key...");
        if (key.isProbablePrime(1024)) {
            System.out.println("  the private key is probably a prime number.");
        } else {
            System.out.println("  the private key is definitely NOT a prime number.");
        }
        
        System.out.println("Verifying (sign-verif)...");
        
        BigInteger msg_orig = msg[0];
        BigInteger sign = msg_orig.modPow(key, n);
        BigInteger msg_verif = sign.modPow(e, n);
        
        if (msg_orig.equals(msg_verif)) {
            System.out.println("  The key is the good one !");
        } else {
            System.out.println("  Sorry, this is not the good key...");
            System.out.println("    original message = " + msg_orig);
            System.out.println("    verified message = " + msg_verif);
        }
        
        //System.out.println("Verifying...");
        //BigInteger 
    }
    
    public static BigInteger dpa(int bit, BigInteger[] msg, int[][] traces, BigInteger n) {
        BigInteger res = null;
        
        if (bit == 1) {
            res = new BigInteger("1");
        } else {
            BigInteger key = dpa(bit - 1, msg, traces, n);
            key = key.multiply(new BigInteger("2"));
            BigInteger key2 = key.multiply(new BigInteger("2"));
            BigInteger key1 = key.add(BigInteger.ONE);
            
            boolean alreadyChosen = false;
            if (dpaStep(key2, msg, traces, n)) {
                res = key;
                alreadyChosen = true;
            }
            
            if (dpaStep(key1, msg, traces, n)) {
                res = key1;
                if (alreadyChosen) {
                    System.out.println("Error: can't decide, two matches !");
                    System.exit(1);
                }
                alreadyChosen = true;
            } 
            
            if (!alreadyChosen) {
                System.out.println("Error: can't decide, no match !");
                System.exit(1);
            }
        }
        
        System.out.println("bit = " + bit + ", key = " + res);
        
        return res;
    }
    
    public static boolean dpaStep(BigInteger power, BigInteger[] msg, int[][] traces, BigInteger n) {
        int tlen = traces[0].length; 
        int[] c0 = new int[tlen];
        int[] c1 = new int[tlen];
        int[] diffP = new int[tlen];
        
        int n0 = 0;
        int n1 = 0;
        
        for (int j = 0; j < traces.length; j++) {
            BigInteger m = msg[j];
            
            int sel = sel(m.modPow(power,n));
            if (sel > 0) {
                for (int k = 0; k < tlen; k++) {
                    c0[k] += traces[j][k];
                }
                n0++;
            } else if (sel < 0) {
                for (int k = 0; k < tlen; k++) {
                    c1[k] += traces[j][k];
                }
                n1++;
            }
        }
        
        // Mean computation
        int sum = 0;
        for (int k = 0; k < tlen; k++) {
            diffP[k] = c0[k] / n0 - c1[k] / n1;
            sum += diffP[k];
        }
        double mean = sum / (n0 + n1);
        
        // Standard deviation computation
        double stddev = 0;
        for (int k = 0; k < tlen; k++) {
            stddev += (diffP[k] - mean) * (diffP[k] - mean);
        }
        stddev = Math.sqrt(stddev / (n0 + n1));
        
        int max = 0;
        for (int k = 0; k < tlen; k++) {
            if (Math.abs(diffP[k]) > max) {
                max = diffP[k];
            }
        }
        
        boolean spike = false;
        if (max > 5 * stddev) {
            spike = true;
        }
        
        return spike;
    }
    
    public static int sel(BigInteger i) {
        // bits are numbered from 0
        
        int res = 0;
        
        if (i.testBit(26) && i.testBit(25) && i.testBit(24)) {
            res = 1;
        } else if (!(i.testBit(26) || i.testBit(25) || i.testBit(24)) ) {
            res = -1;
        }
        
        return res;
    }
    
    public static String goodform(int i) {
        String str = Integer.toString(i);
        
        int len = str.length();
        for (int j = 0; j < 5 - len; j++) {
            str = "0" + str;
        }
        
        return str;
    }
    
}
