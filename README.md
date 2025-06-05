# HTML-3_JSTL_Dynamic_applet

> **A role-based JSP / JSTL web app that for product certification**

## Table of Contents
1. [Project overview](#project-overview)
2. [Architecture](#architecture)
4. [Tech stack](#tech-stack)
5. [Getting started](#getting-started)
6. [Folder structure](#folder-structure)
7. [Contributing](#contributing)
8. [License](#license)
9. [Original functional specification](#original-functional-specification)

---

## Project overview
HTML-3_JSTL_Dynamic_applet is a multi-tenant web portal that replaces manual product-certification paperwork with a single, traceable workflow for manufacturers (CPR), government reviewers (GOV), certified auditors (CERT) and accredited laboratories (LAB).

**Highlights**

| Feature | Why it matters |
|---------|----------------|
| **Complete lifecycle**: request → test prescription → lab bidding → certification | One tool for every stakeholder |
| **Role-based JSP views** | The UI adapts dynamically to user type via JSTL conditional tags |
| **Real-time KPIs** | Dashboards expose turnover, average costs, top LABs & more |
| **Lean front-end bundle** | Optimised images and minified assets for faster first paint |

---


## Architecture
```text
Browser ─▶ JSP / JSTL Views ─▶ Servlet Controllers ─▶ DAO layer ─▶ RDBMS
         ▲           │
         └── assets ─┘  (Bootstrap 5, jQuery, FontAwesome)
```
* Stateless controllers + session authentication  
* JSTL `<c:choose>` & `<c:if>` drive role-aware rendering  
* DAO layer ready for MySQL/PostgreSQL (JDBC) – simply update `db.properties`

---

## Tech stack
| Tier | Tech |
|------|------|
| Front-end | HTML 3, CSS 3, Bootstrap 5, jQuery |
| View | JSP 2.3, JSTL 1.2, JSPF partials |
| Back-end | Java 8+, Jakarta Servlet 4.0 |
| Build / Deploy | Maven, Apache Tomcat 9 |
| Test | JUnit 5, Selenium 4 |

---

## Getting started

### Prerequisites
* JDK 8+ • Maven 3.8 • Docker (optional) • MySQL 8 (or PostgreSQL 13)

### Local setup
```bash
git clone https://github.com/simonc999/HTML-3_JSTL_Dynamic_applet.git

cd HTML-3_JSTL_Dynamic_applet

mvn clean package

cp target/HTML-3_JSTL_Dynamic_applet.war $CATALINA_BASE/webapps

$CATALINA_BASE/bin/startup.sh

```

### First-time configuration
1. Import `db/schema.sql` into your RDBMS.  
2. Edit `WEB-INF/classes/db.properties` with your credentials.  
3. Restart Tomcat and log in with the seed users in `docs/seed-data.md`.

---

## Folder structure
```text
.  
├─ binary/            # Optimised PNG/JPEG assets  
├─ pages/             # 110+ JSP views & JSPF fragments  
└─ README.md          
```

---

## Citation

If you use this toolkit for academic work, please cite:

```bibtex
@software{HTML-3_JSTL_Dynamic_applet,
  author  = {simonc999},
  title   = {HTML-3_JSTL_Dynamic_applet},
  year    = {2025},
  url     = {https://github.com/simonc999/HTML-3_JSTL_Dynamic_applet}
}
```

---




# HTML-3_JSTL_Dynamic_applet
This repository contains a front-end programming project without the use of CSS and with the presence of dynamic pages to register products, certify them, and approve them.


The company Alambiccus SRI (**ALA**) was established to facilitate the interaction among Product Manufacturers (**CPR**), Product Producers (**PROD**), Certified Professionals (**CERT**) registered with the association, and Accredited Laboratories (**LAB**) for conducting material analysis / testing (**TEST**). ALA does not possess chemical or pharmaceutical expertise, but it offers an intermediation service among the various stakeholders, coordinating their activities and ensuring the traceability of the certification process, which is regulated and overseen by a Government Agency (**GOV**). ALA operates a web application through which the stakeholders interact according to the following high-level workflow, detailed further in the paragraphs concerning the functionalities of the various roles:

1. Each CPR creates records for their PROD, indicating all characteristics.
2. CPR initiates the PROD certification process, generating a request visible to GOV.
3. GOV reviews the certification request and assigns it to a CERT as the responsible party.
4. CERT sees the PROD in their management and plans the certification process.
5. CERT prescribes a series of TESTs chosen from standardized types defined and approved by GOV.
6. For each TEST, CERT also fills out additional textual fields (purposes, objectives, expected results, etc.).
7. LABs view the TEST prescriptions, limited to the types they can perform.
8. LABs apply to perform TESTs, indicating the details (e.g., samples, timing, etc.).
9. For each TEST, CPR views the candidate LABs along with their indicated methods and costs.
10. CPR assigns a LAB for each TEST, paying the cost deducted from their account.
11. The assigned LAB accesses a messaging interface with PROD to coordinate details.
12. After conducting the TEST, the assigned LAB enters the outcome (Passed / Not Passed) and prepares a report.
13. CERT can review the certification path of managed PROD at any time. The process is chronologically organized and includes the list of all prescribed TESTs with related messages exchanged between PROD and LAB, eventual conclusive TEST outcomes, and related reports.
14. CERT can prescribe additional TESTs before the certification process concludes.
15. When all prescribed TESTs are conducted (i.e., have outcomes and reports), CERT, if the process is deemed complete, generates a conclusive report and closes the case (Certified / Not Certified).
16. Once the case is closed, no further operations are allowed, and CPR is notified of the outcome.

Access to the system is granted upon authentication, and the following detailed functionalities are attributed to the 5 roles: ALA, GOV, CERT, LAB, and CPR. Additionally, there's a section containing publicly accessible information that doesn't require authentication.

## CPR functionalities:
Various CPRs access the website to request certification for their PROD, follow the procedure, interact with the LABs conducting the TESTs, and view the final outcome.
1. A CPR self-registers on the site, creating an account with their details (Company Name, VAT Number, Legal Address, Representative, etc.). After self-registration, the account only allows login/logout operations. However, activities related to PROD are not permitted until the new account is validated by AIA.
2. Creates PROD records for certification. Each record contains all information that characterizes the PROD properly organized (name, type, form, use, ingredients or materials, characteristics). The PROD record can be updated at any time until certification is requested.
3. Initiates the certification process for a PROD, "freezing" the associated record, which can no longer be modified.
4. Whenever CERT prescribes a new TEST, CPR is informed (e.g., through a notification) and can view the instructions provided by CERT (including the CERT's identity requesting it).
5. Makes deposits into a prepaid account with a visible balance. The balance is used in a trickle-down manner to pay the LABs performing the TESTs on the PROD.
6. When a LAB offers to conduct a TEST, CPR is notified (e.g., through a notification) and can proceed in either of the following ways:
   - Selects one of the candidate LABs and assigns them to conduct the TEST, paying the associated cost.
   - Cancels the TEST's execution by all candidate LABs, providing a reason (e.g., product withdrawn). This immediately completes the PROD's process with a "Not Certified" status.
7. From the moment CPR assigns a LAB for a TEST, they can message it without particular restrictions until the TEST's conclusion.
8. Can always view all records of their PROD; can navigate through all chronologically ordered TEST prescriptions, viewing the CERT's reasons, messages exchanged with the assigned LABs, and the outcomes provided by them; can view the certification status and conclusive reports provided by CERT if already available.

## ALA functionalities:
ALA serves as the System Administrator and is assumed to have a single user account (predefined within the application) with the following functions:
1. Creates accounts for various LABs (credentials are communicated to LABs externally to the site).
2. Views the accounts of CPRs registered on the site, both new ones (highlighted) and those already validated, along with all entered data.
3. Validates new CPR accounts after verifying that the data is accurate (external verification is assumed), allowing them to become fully operational.

## GOV functionalities:
GOV oversees the entire PROD certification process. It is assumed to connect through a single user account (predefined within the application) with functions that include:
1. Management (creation / suspension) of user accounts for CERTs registered with the association.
2. Creation / viewing / updating of TEST types (laboratory analysis or material testing) defined by regulations. For each type, it always indicates a minimum and maximum cost.
3. Views the PROD records present on the site, both certified ones and those in the certification process, with information about progress and CERT's potential conclusive reports. It also displays all TESTs requested for each PROD by CERT with their reasons and outcomes. However, it cannot view PRODs for which certification has not yet been requested. PROD records can be searched and filtered based on various criteria, including:
   - PROD Name / Company Name
   - PROD for which a type of test/analysis has been prescribed
   - PROD with completed process (certified / not certified) / PROD under certification

## LAB functionalities:
Each LAB is accredited to perform TESTs specified by GOV. LAB accounts are created by AIA, and their functionalities include:
1. Listing TESTs that it can conduct (subset of standardized types), indicating the cost (between the minimum and maximum provided by GOV).
2. When CERT prescribes a TEST that is within its capabilities, LAB is informed (e.g., through notifications) and can view the prescription, PROD, and CPR records.
3. After viewing the records, LAB can offer to conduct the TEST. This offer becomes void, along with the visibility of PROD and CPR, if CPR assigns another LAB or withdraws the PROD's certification.
4. If LAB is assigned by CPR to conduct a TEST, it receives the expected cost, which increases its revenues, and it can start messaging CPR. After concluding the TEST, it must provide an outcome (Passed / Not Passed) and prepare a report.
5. After concluding a TEST, it cannot message CPR anymore, but the associated TEST record along with PROD and CPR remain visible, as well as any exchanged messages.

## CERT functionalities:
CERT is a professional registered with an association who manages the certification process of PRODs. Their accounts are created by GOV, and each CERT account has the following functionalities:
1. Views all records only for PRODs currently assigned to them by GOV.
2. For each PROD they manage, besides the descriptive record, they can view the chronological list of TESTs with indications of the CERTs who prescribed them, their reasons, and potential outcomes with reports from LABs if the TESTs have already been conducted.
3. At any point during the certification process of a PROD they manage, they can prescribe additional TESTs by completing additional fields (purposes, objectives, etc.).
4. When the certification process of a PROD concludes or if CERT is relieved from the assignment, they lose visibility of the PROD.

## Public Functionality:
1. Introduction to the site.
2. Section with various statistics:
   - Total number of prescribed/conducted TESTs.
   - Business turnover (total payment sum).
   - Indication of revenues for each LAB.
   - Average cost incurred for PROD certification.
